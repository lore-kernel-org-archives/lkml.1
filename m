Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYBKQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYBKQoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbYBKQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:44:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:49146 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYBKQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gYnzV7sHh4Pk6vypg8mQ4wn5Ea7FkfW6z89aVPb5OWBC9PrgWMixPTYUYdsYyLmwO6QGoVhphZUKmlZIllNxorDcwH9ZPr8ZfCTO7aVsP2/x2otbZXGuIqmzk+2Bl+VltHFbDehopmwmuXcfhUJ7I4rJitKuEes9KKkhvcgATwI=
Message-ID: <751a4f870802110844m6c034664m5c0713df1d29eae3@mail.gmail.com>
Date: Mon, 11 Feb 2008 17:44:08 +0100
From: "Aron Stansvik" <elvstone@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML.

Under semi-high disk I/O (e.g. installing a compiled KDE), I get the
following (accompanied by seconds of lock-ups on the machine):

[ 7727.345183] arcmsr0: abort device command of scsi id = 0 lun = 0
[ 7730.348776] arcmsr0:                 scsi id = 0 lun = 0 ccb =
'0xdfb461c0' poll command abort successfully
[ 8053.795943] arcmsr0: abort device command of scsi id = 0 lun = 0
[ 8056.799528] arcmsr0:                 scsi id = 0 lun = 0 ccb =
'0xdfb595e0' poll command abort successfully
[ 8884.592810] arcmsr0: abort device command of scsi id = 0 lun = 0
[ 8887.596392] arcmsr0:                 scsi id = 0 lun = 0 ccb =
'0xdfb56d80' poll command abort successfully
[ 8917.760216] arcmsr0: abort device command of scsi id = 0 lun = 0
[ 8920.763797] arcmsr0:                 scsi id = 0 lun = 0 ccb =
'0xdfb472c0' poll command abort successfully
[ 9074.106547] arcmsr0: abort device command of scsi id = 0 lun = 0

This is my setup:

1 x MSI K8N Master2-FAR
1 x Opteron 252
1 x Areca ARC1200 (sitting in a PCIe x4 socket)
2 x WD1500ADFD in RAID1

astan@rubik:~$ uname -a
Linux rubik 2.6.24-7-generic #1 SMP Thu Feb 7 01:29:58 UTC 2008 i686 GNU/Linux
astan@rubik:~$ modinfo arcmsr
filename:
/lib/modules/2.6.24-7-generic/kernel/drivers/scsi/arcmsr/arcmsr.ko
version:        Driver Version 1.20.00.15 2007/08/30
license:        Dual BSD/GPL
description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST Adapter
author:         Erich Chen <support@areca.com.tw>
srcversion:     28EAD6AB49D4491CA04D465
[...]

I've read some previous posts here on LKML that it could be the Areca
firmware who doesn't like my WD disks. Anyone know if this is an IRQ
handling problem in the kernel, or if it's a problem with the RAID
controller firmware?

Erich Chen (of Areca); have you tried the new ARC1200 in RAID1
configuration with Raptor disks on Linux?

As a side note, I can tell you that I first tried running FreeBSD 6.3
(RELENG_6) on this machine, but got random reboots during disk I/O
(even with a kernel with KDB debugging turned on). This leads me to
believe that it might be a firmware issue, and that Linux just handles
it more gracefully than FreeBSD.

Any ideas or advice is appriciated. This is my first post to the LKML,
so please instruct me if you want more information or if you want me
to take further debugging actions.

Best regards,
Aron Stansvik
