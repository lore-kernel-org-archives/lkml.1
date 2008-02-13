Return-Path: <linux-kernel-owner+w=401wt.eu-S1765109AbYBMIEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765109AbYBMIEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbYBMIEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:04:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbYBMIEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:04:37 -0500
Date: Wed, 13 Feb 2008 00:03:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aron Stansvik" <elvstone@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       erich <erich@areca.com.tw>
Subject: Re: Aborted commands with arcmsr and 2xWD1500ADFD in RAID1
Message-Id: <20080213000303.e86bd125.akpm@linux-foundation.org>
In-Reply-To: <751a4f870802110844m6c034664m5c0713df1d29eae3@mail.gmail.com>
References: <751a4f870802110844m6c034664m5c0713df1d29eae3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's added)

On Mon, 11 Feb 2008 17:44:08 +0100 "Aron Stansvik" <elvstone@gmail.com> wrote:

> Hello LKML.
> 
> Under semi-high disk I/O (e.g. installing a compiled KDE), I get the
> following (accompanied by seconds of lock-ups on the machine):
> 
> [ 7727.345183] arcmsr0: abort device command of scsi id = 0 lun = 0
> [ 7730.348776] arcmsr0:                 scsi id = 0 lun = 0 ccb =
> '0xdfb461c0' poll command abort successfully
> [ 8053.795943] arcmsr0: abort device command of scsi id = 0 lun = 0
> [ 8056.799528] arcmsr0:                 scsi id = 0 lun = 0 ccb =
> '0xdfb595e0' poll command abort successfully
> [ 8884.592810] arcmsr0: abort device command of scsi id = 0 lun = 0
> [ 8887.596392] arcmsr0:                 scsi id = 0 lun = 0 ccb =
> '0xdfb56d80' poll command abort successfully
> [ 8917.760216] arcmsr0: abort device command of scsi id = 0 lun = 0
> [ 8920.763797] arcmsr0:                 scsi id = 0 lun = 0 ccb =
> '0xdfb472c0' poll command abort successfully
> [ 9074.106547] arcmsr0: abort device command of scsi id = 0 lun = 0
> 
> This is my setup:
> 
> 1 x MSI K8N Master2-FAR
> 1 x Opteron 252
> 1 x Areca ARC1200 (sitting in a PCIe x4 socket)
> 2 x WD1500ADFD in RAID1
> 
> astan@rubik:~$ uname -a
> Linux rubik 2.6.24-7-generic #1 SMP Thu Feb 7 01:29:58 UTC 2008 i686 GNU/Linux
> astan@rubik:~$ modinfo arcmsr
> filename:
> /lib/modules/2.6.24-7-generic/kernel/drivers/scsi/arcmsr/arcmsr.ko
> version:        Driver Version 1.20.00.15 2007/08/30
> license:        Dual BSD/GPL
> description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST Adapter
> author:         Erich Chen <support@areca.com.tw>
> srcversion:     28EAD6AB49D4491CA04D465
> [...]
> 
> I've read some previous posts here on LKML that it could be the Areca
> firmware who doesn't like my WD disks. Anyone know if this is an IRQ
> handling problem in the kernel, or if it's a problem with the RAID
> controller firmware?
> 
> Erich Chen (of Areca); have you tried the new ARC1200 in RAID1
> configuration with Raptor disks on Linux?
> 
> As a side note, I can tell you that I first tried running FreeBSD 6.3
> (RELENG_6) on this machine, but got random reboots during disk I/O
> (even with a kernel with KDB debugging turned on). This leads me to
> believe that it might be a firmware issue, and that Linux just handles
> it more gracefully than FreeBSD.
> 
> Any ideas or advice is appriciated. This is my first post to the LKML,
> so please instruct me if you want more information or if you want me
> to take further debugging actions.
> 
> Best regards,
> Aron Stansvik

