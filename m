Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbZHLHsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbZHLHsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZHLHsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:48:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbZHLHsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:48:04 -0400
Date: Wed, 12 Aug 2009 09:47:53 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-hotplug@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD
	is set" fails on my system
Message-ID: <20090812074753.GL13320@pengutronix.de>
References: <200908111830.03224.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908111830.03224.jbe@pengutronix.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:47:05 up 6 days, 19:06, 14 users,  load average: 2.14, 2.94,
	1.98
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jürgen,

adding the patch author to Cc: ...

rsc

On Tue, Aug 11, 2009 at 06:30:02PM +0200, Juergen Beisert wrote:
> Hi,
> 
> I get the following Ooops message when "udevadm" is running on an ARM S3C2440
> CPU based system:
> 
> [...]
> starting udevd...done
> Unable to handle kernel paging request at virtual address e3540000
> pgd = c39d4000
> [e3540000] *pgd=00000000
> Internal error: Oops: 5 [#1]
> Modules linked in:
> CPU: 0    Not tainted  (2.6.31-rc4-00296-ge084b2d-dirty #10)
> PC is at strlen+0xc/0x20
> LR is at kobject_get_path+0x24/0xa4
> pc : [<c0115338>]    lr : [<c0111f48>]    psr: a0000013
> sp : c39bdea0  ip : 00000005  fp : c029645b
> r10: c02e0430  r9 : 00000000  r8 : c3802c60
> r7 : c001de30  r6 : 000000d0  r5 : 00000001  r4 : c001de30
> r3 : e3550001  r2 : e3540000  r1 : 000000d0  r0 : e3540000
> Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: c000717f  Table: 339d4000  DAC: 00000015
> Process udevadm (pid: 325, stack limit = 0xc39bc270)
> Stack: (0xc39bdea0 to 0xc39be000)
> dea0: c001de28 00000003 c393d778 c399d000 c3802c60 c014dce0 c029645b c0112200
> dec0: c393d778 00000000 00000003 c393d780 c399d000 c0112400 00000000 00020001
> dee0: c0307fdc 00000000 c3950960 c027ddc3 c380cda0 c343b3d4 c3811e60 00000000
> df00: 00000000 c393d778 00000003 c3960520 c393d780 c02e0470 c3960538 c39bdf88
> df20: 00019cb0 c014dd80 c382db20 00000000 c3960538 c38ede7c 00000003 c014d464
> df40: c38ede7c c00bf224 c382db20 00019cb0 c39bdf88 00000004 00000003 c39bc000
> df60: 00000000 c0080bd8 c343b3d4 00000020 00000000 00000000 c382db20 00000004
> df80: c0022fa8 c0080d38 00000000 00000000 bead3250 00000000 00026d98 00000003
> dfa0: bead3250 c0022e00 00026d98 00000003 00000003 00019cb0 00000003 00000000
> dfc0: 00026d98 00000003 bead3250 00000004 00022a90 bead3678 00019cb0 00019cb0
> dfe0: 00022a94 bead3250 00018114 400d8f1c 40000010 00000003 00000000 00000000
> [<c0115338>] (strlen+0xc/0x20) from [<c0111f48>] (kobject_get_path+0x24/0xa4)
> [<c0111f48>] (kobject_get_path+0x24/0xa4) from [<c014dce0>] (dev_uevent+0x1dc/0x208)
> [<c014dce0>] (dev_uevent+0x1dc/0x208) from [<c0112400>] (kobject_uevent_env+0x18c/0x3a8)
> [<c0112400>] (kobject_uevent_env+0x18c/0x3a8) from [<c014dd80>] (store_uevent+0x74/0x88)
> [<c014dd80>] (store_uevent+0x74/0x88) from [<c014d464>] (dev_attr_store+0x20/0x28)
> [<c014d464>] (dev_attr_store+0x20/0x28) from [<c00bf224>] (sysfs_write_file+0x104/0x13c)
> [<c00bf224>] (sysfs_write_file+0x104/0x13c) from [<c0080bd8>] (vfs_write+0xb0/0x15c)
> [<c0080bd8>] (vfs_write+0xb0/0x15c) from [<c0080d38>] (sys_write+0x40/0x6c)
> [<c0080d38>] (sys_write+0x40/0x6c) from [<c0022e00>] (ret_fast_syscall+0x0/0x2c)
> Code: c02dbe78 e1a02000 ea000000 e2800001 (e5d03000)
> ---[ end trace 4d391449ae70e71a ]---
> Segmentation fault
> [...]
> 
> This Oops does not occure in v2.6.31-rc4 and occures in v2.6.31-rc5. Bisected
> to the commit:
> 
> e084b2d95e48b31aa45f9c49ffc6cdae8bdb21d4
> "page-allocator: preserve PFN ordering when __GFP_COLD is set"
> 
> But its curious: The same binary kernel still runs without this oops on an ARM
> S3C2410 CPU.
> 
> Regards,
> Juergen
> 
> -- 
> Pengutronix e.K.                              | Juergen Beisert             |
> Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
> Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
