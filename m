Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZENVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZENVsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZENVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:48:23 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38967 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZENVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:48:22 -0400
Date: Thu, 14 May 2009 16:48:19 -0500
From: Scott Wood <scottwood@freescale.com>
To: Heiko Schocher <hs@denx.de>
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash, size
Message-ID: <20090514214819.GA15549@b07421-ec1.am.freescale.net>
References: <mailman.7754.1242158509.26545.linuxppc-dev@ozlabs.org> <4A0A683B.5010209@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A683B.5010209@denx.de>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 08:27:07AM +0200, Heiko Schocher wrote:
> Hello Wolfgang,
> 
> > The current device tree for the MPC8272ADS assumes a mapping of 32 MB
> > of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
> > the boards, mapped at 0xFF80.0000. When booting an uImage with such a
> > device tree, the kernel crashes because 0xFE00.0000 is not mapped.
> 
> Wouldn;t it be better, if u-boot fixes the device tree entries?

We should proabbly leave out the ranges altogether, and have u-boot
populate it from the mappings it establishes.

> I think, u-boot should know, where the flash begins and ends, and
> because this is maybe a dynamic variable for this board, it should
> be better, if u-boot fixes this, so no need for adding a device tree
> for every board variant.

Flash is on a SIMM on this board, and the board manual says it's
expandable to 32 MiB.  However, I suspect that the current DTS was just
an error as I based it on a board that had not had its flash SIMM
modified.  That specific flash SIMM is no longer working (or perhaps just
got its contents corrupted -- one of these days I may hook up a BDI and
try to reflash), so I can't go back and check.

I don't see how current u-boot would accomodate more than 8MiB flash on
this board (there's some detection in board/freescale/mpc8260ads/flash.c,
but I don't see any setting of BR0 besides the preliminary value at
0xff800000).

-Scott
