Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKUQZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKUQZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYKUQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:25:25 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36154 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbYKUQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:25:24 -0500
Message-ID: <4926E0F2.5060200@lwfinger.net>
Date: Fri, 21 Nov 2008 10:25:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Stuge <peter@stuge.se>, wireless <linux-wireless@vger.kernel.org>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       Yuval Hager <yuval@avramzon.net>
Subject: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net>	<491EFB9D.3040002@lwfinger.net>	<200811151907.05636.yuval@avramzon.net> <20081115174623.27321.qmail@stuge.se>
In-Reply-To: <20081115174623.27321.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A problem was recently posted to the bcm43xx mailing list that I am unable to
solve. The machine in question is an HP Mini 2133 (HP product number FU346EA)
with a BCM4312 PCIe wireless card. This card is known to work with the b43
driver (I have one.) and it does work on this machine - at least initially.

A problem occurs when xdm/kde is started. Suddenly a read operation on device
hardware returns all ones as though the register does not exist, or if it were
suddenly mismapped. If the OP doesn't try to run xdm, the same problem will
eventually occur, it just takes longer.

This is a 32-bit system running 2.6.28-rc5, but I don't think this is a
regression from some earlier version as the problem was first reported with
kernel 2.6.27-gentoo-r2.

I have complete logs, but before spamming the list with them, I have a question
about the "Zone PFN" settings. On the problem machine, the following list occurs:

[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0006feb0

On my 64-bit HP machine, I see:

Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000

Is it "normal" for there not to be a DMA32 range with a 32-bit version of Linux?
Certainly all the memory is available to 32-bit DMA. This card does 64-bit DMA,
but the driver falls back to a 32-bit mask for this system.

Is there some kind of memory mapping problem in the PCIe system? Should the
entire log be posted?

Thanks,

Larry
