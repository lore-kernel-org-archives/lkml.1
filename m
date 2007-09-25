Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXIYJIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXIYJIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXIYJIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:08:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:33790 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXIYJI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:references:subject:message-id:x-mailer;
        b=gRy+K+gKWwEVTTUbkk5vGtPMhsxQA7DyWWhF8Djshq0WtwpFKM1QjVK/ntNUyI5KsahUu8xDOBV/RlM6G76lPWd1R+j3HQQtXGBLy6dhIY6m0UHBnpcoD0FHT/TnZ0gRNHHpYH2/pW00XBm1WNdneRlmDcVYIpS/rj/LJ+YmUD8=
Date: Tue, 25 Sep 2007 17:08:23 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "jeff" <jeff@garzik.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
References: <200709251323031982245@gmail.com>,
 <46F8B3F8.1050909@garzik.org>,
 <200709251552483357334@gmail.com>,
 <46F8C33A.3060601@garzik.org>
Subject: Re: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Message-ID: <200709251708208579514@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,I hear what you are saying but user should know what they are setting in BIOS,there are lots of ways to change the BIOS setting result in unbootable system not only change AHCI/IDE mode. If they encounter booting failure after changing the BIOS setting,they should restore it.
Using legacy driver for legacy mode won't affect user to enjoy the feature of AHCI,just select AHCI/RAID mode will ok.
As I know, Intel did it in the same way,and I think it's reasonable.


------------------				 
Peer Chen
2007-09-25

-------------------------------------------------------------
发件人：Jeff Garzik
发送日期：2007-09-25 16:13:52
收件人：Peer Chen
抄送：linux-kernel; linux-ide; akpm
主题：Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv

Peer Chen wrote:
> We have three mode for one controller - IDE/RAID/AHCI, we want sata_nv being load when user select the IDE mode in BIOS, load ahci driver if RAID/AHCI being selected, which will verify if our legacy mode work well and have additional option if there is any
> bug for the ahci mode.

I understand that logic, but look at what happens in practice:

1) User installs new OS in AHCI mode.  Distro updates initramfs (loaded 
at kernel boot time, with boot drivers) to include ahci driver.
2) User reboots into BIOS setup, and switches from AHCI mode to IDE mode.
3) BIOS setup reboots computer.
4) OS kernel and initramfs image are loaded.  ahci driver load fails.
5) User is left without a bootable system.

The same situation happens in reverse, if you install in IDE mode 
(sata_nv in initramfs), and then switch to AHCI/RAID mode.

Additionally, AHCI provides better performance and more direct exposure 
to the SATA frames.  This is key for supporting many modern SATA 
features that cannot be accessed via IDE legacy mode.  AHCI lacks 
in-silicon simulation of an IDE interface, which time has shown is a 
less stable, edge-case-prone approach to SATA.

I do not find the "verify nvidia's legacy mode works" argument 
compelling; that is not the kernel's job, nor the user's.  And if there 
is an AHCI silicon bug, let us deal with that when such a bug appears.

Overall, AFAICS this patch -introduces- new ways for the user to easily 
render their systems unbootable.

	Jeff



