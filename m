Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXKUWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXKUWmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXKUWlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:41:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbXKUWlu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:41:50 -0500
Date: Wed, 21 Nov 2007 14:41:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Message-Id: <20071121144116.c932727b.akpm@linux-foundation.org>
In-Reply-To: <4744A6F2.4030302@free.fr>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4744A6F2.4030302@free.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 22:45:22 +0100
Laurent Riffard <laurent.riffard@free.fr> wrote:

> Le 21.11.2007 05:45, Andrew Morton a écrit :
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
> 
> Hello, 
> 
> My system hangs shortly after I logged in Gnome desktop. SysRq-W shows
> that a bunch of task are blocked in "D" state, they seem to wait for
> some I/O completion. I can try to hand-copy some data if requested.
> 
> I found these messages in dmesg:
> 
> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1 
> EXT3-fs: mounted filesystem with ordered data mode.
> sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sda, sector 16460
> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
> ReiserFS: sda7: using ordered data mode
> --
> ReiserFS: sda7: Using r5 hash to sort names
> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdb, sector 19632
> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdb, sector 40037363
> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
> lp0: using parport0 (interrupt-driven).
> 
> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reproducible.
> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
> 
> Maybe something is broken in pata_via driver ?
> 

Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
touch pata_via.c.
