Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZEOPgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZEOPgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZEOPgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:36:38 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:42737 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEOPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:36:38 -0400
Date: Fri, 15 May 2009 10:36:19 -0500
From: Scott Wood <scottwood@freescale.com>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@ozlabs.org, Wolfgang Denk <wd@denx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash, size
Message-ID: <20090515153619.GA24872@b07421-ec1.am.freescale.net>
References: <mailman.7754.1242158509.26545.linuxppc-dev@ozlabs.org> <4A0A683B.5010209@denx.de> <20090514214819.GA15549@b07421-ec1.am.freescale.net> <4A0D03AB.2040602@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0D03AB.2040602@denx.de>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 07:54:51AM +0200, Heiko Schocher wrote:
> Scott Wood wrote:
> > We should proabbly leave out the ranges altogether, and have u-boot
> > populate it from the mappings it establishes.
> 
> No, I vote for manipulating just the entries, which u-boot dynamically
> detect, and let the other entries untouched. It is possible that
> there is a device which u-boot didn;t use/know, and there is in the DTS
> an ranges entry for it (Maybe not on the MPC8727ADS, but we should
> define a rule, how a bootloader has to manipulate entries). So if
> u-boot build the complete ranges entry, it maybe miss something.

If u-boot doesn't know about it, then it didn't create the mapping, and
thus it's not accessible (if something later on creates a mapping, it can
update ranges itself).  The devices themselves would still be described,
just not the non-existent mapping.

The benefit is that you would have just one place that reads out the
localbus config into the device tree, with no error-prone duplication of
data, or separate hacks for each board that has something that is
variable.

We could leave ranges in the dts for cuImage, and have u-boot just
overwrite the entire thing rather than patch up individual entries.

> > I don't see how current u-boot would accomodate more than 8MiB flash on
> > this board (there's some detection in board/freescale/mpc8260ads/flash.c,
> 
> Didn;t this board uses the CFI driver? :-(

Not yet, unfortunately.  This is pretty old code.

-Scott
