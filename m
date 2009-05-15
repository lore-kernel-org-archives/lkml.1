Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbZEOGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbZEOGJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZEOGJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:09:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60905 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbZEOGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:09:44 -0400
X-Auth-Info: YVrg4tyv2M6dDJo8RNwxpDaSmFf6LW/++EeWkI09t1c=
Message-ID: <4A0D03AB.2040602@denx.de>
Date: Fri, 15 May 2009 07:54:51 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX GmbH
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Wolfgang Denk <wd@denx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash,
 size
References: <mailman.7754.1242158509.26545.linuxppc-dev@ozlabs.org> <4A0A683B.5010209@denx.de> <20090514214819.GA15549@b07421-ec1.am.freescale.net>
In-Reply-To: <20090514214819.GA15549@b07421-ec1.am.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Scott,

Scott Wood wrote:
> On Wed, May 13, 2009 at 08:27:07AM +0200, Heiko Schocher wrote:
>> Hello Wolfgang,
>>
>>> The current device tree for the MPC8272ADS assumes a mapping of 32 MB
>>> of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
>>> the boards, mapped at 0xFF80.0000. When booting an uImage with such a
>>> device tree, the kernel crashes because 0xFE00.0000 is not mapped.
>> Wouldn;t it be better, if u-boot fixes the device tree entries?
> 
> We should proabbly leave out the ranges altogether, and have u-boot
> populate it from the mappings it establishes.

No, I vote for manipulating just the entries, which u-boot dynamically
detect, and let the other entries untouched. It is possible that
there is a device which u-boot didn;t use/know, and there is in the DTS
an ranges entry for it (Maybe not on the MPC8727ADS, but we should
define a rule, how a bootloader has to manipulate entries). So if
u-boot build the complete ranges entry, it maybe miss something.

>> I think, u-boot should know, where the flash begins and ends, and
>> because this is maybe a dynamic variable for this board, it should
>> be better, if u-boot fixes this, so no need for adding a device tree
>> for every board variant.
> 
> Flash is on a SIMM on this board, and the board manual says it's
> expandable to 32 MiB.  However, I suspect that the current DTS was just
> an error as I based it on a board that had not had its flash SIMM
> modified.  That specific flash SIMM is no longer working (or perhaps just
> got its contents corrupted -- one of these days I may hook up a BDI and
> try to reflash), so I can't go back and check.
> 
> I don't see how current u-boot would accomodate more than 8MiB flash on
> this board (there's some detection in board/freescale/mpc8260ads/flash.c,

Didn;t this board uses the CFI driver? :-(

> but I don't see any setting of BR0 besides the preliminary value at
> 0xff800000).

OK, then the patch from Wolfgang should be sufficient.

bye
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
