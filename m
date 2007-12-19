Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbXLSRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbXLSRAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXLSRAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:00:35 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:1459 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbXLSRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:00:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wMDWrVSLLfYKEFvoVcARpbmegLHaysVsrMT5T6sdOWGxKlEOgrCqjPQ0fn1r+Cg1FUBvmKxerZDfFMTw/v/zPlWIc7dDNAG8acdeXiDHxLOtjGLrTlC2oJb58V1350fLzreIusFFm6hvo1yzNFLP3wyPz+18q7xwmjvZDeqO3qk=
Message-ID: <82e4877d0712190900y17670831k51429996f78e954a@mail.gmail.com>
Date: Wed, 19 Dec 2007 12:00:31 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20071219165420.GA15291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
	 <20071219104823.GI3521@elte.hu>
	 <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com>
	 <20071219165420.GA15291@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 11:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
> > --- 2.6.24-rc5-patched        2007-12-19 07:21:05.000000000 -0500
> > +++ 2.6.24-rc5-new    2007-12-19 11:36:54.000000000 -0500
>
> hm, i see no OOM messages in the diff - what am i missing?
>
> best would be to run:
>
>  sort 2.6.24-rc5-patched > new.log
>  sort 2.6.24-rc5-new > old.log
>  diff -up old.log new.log
>
> to remove line ordering issues.

Pasted the wrong diff - just wanted to feel normal about the day I guess.

Here is the right one -
2.6.24-rc5  is without patch, 2.6.24-rc5-new is with patch.

--- old.log	2007-12-19 11:59:15.000000000 -0500
+++ new.log	2007-12-19 11:59:08.000000000 -0500
@@ -76,7 +76,7 @@ ahci 0000:00:1f.2: flags: 64bit ncq sntf
 ahci 0000:00:1f.2: version 3.0
 Allocate Port Service[0000:00:01.0:pcie00]
 Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
-APIC timer calibration result 12499727
+APIC timer calibration result 12499803
 assign_interrupt_mode Found MSI capability
 ata1: SATA link down (SStatus 0 SControl 310)
 ata1: SATA max UDMA/100 mmio m512@0xf9ffec00 tf 0xf9ffec80 irq 17
@@ -105,8 +105,8 @@ ata8.00: ATA-7: ST3300622AS, 3.AAH, max
 ata8.00: configured for UDMA/133
 ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 ata8: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff380 irq 318
-audit(1198063330.636:1): initialized
-audit(1198063349.305:2): policy loaded auid=4294967295
+audit(1198064108.636:1): initialized
+audit(1198064127.320:2): policy loaded auid=4294967295
 audit: initializing netlink socket (disabled)
  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
@@ -133,8 +133,8 @@ Boot video device is 0000:02:00.0
 Bridge firewalling registered
 Brought up 2 CPUs
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1547375
-Calibrating delay using timer specific routine.. 4399.87 BogoMIPS (lpj=8799757)
-Calibrating delay using timer specific routine.. 4403.76 BogoMIPS (lpj=8807520)
+Calibrating delay using timer specific routine.. 4399.95 BogoMIPS (lpj=8799915)
+Calibrating delay using timer specific routine.. 4403.90 BogoMIPS (lpj=8807800)
 Capability LSM initialized as secondary
 Checking aperture...
 checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
@@ -164,8 +164,6 @@ device-mapper: multipath: version 1.0.5
   DMA zone: 2823 pages, LIFO batch:0
   DMA zone: 56 pages used for memmap
 DMI present.
-dmi_save_oem_strings_devices: out of memory.
-dmi_string: out of memory.
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
 e1000e: Copyright (c) 1999-2007 Intel Corporation.
@@ -227,9 +225,9 @@ Initializing XFRM netlink socket
 Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
 input: AT Translated Set 2 keyboard as /class/input/input1
 input: ImPS/2 Generic Wheel Mouse as /class/input/input0
-input: PC Speaker as /class/input/input2
+input: PC Speaker as /class/input/input3
 input: Power Button (CM) as /class/input/input4
-input: Power Button (FF) as /class/input/input3
+input: Power Button (FF) as /class/input/input2
 Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
 IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
 io scheduler anticipatory registered
@@ -251,7 +249,7 @@ ldm_parse_tocblock(): Cannot find TOCBLO
 libata version 3.00 loaded.
 Linux agpgart interface v0.102
 Linux Plug and Play Support v0.97 (c) Adam Belay
-Linux version 2.6.24-rc5 (parag@pavillion.hsd1.mi.comcast.net) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Wed Dec 19 07:39:04
EST 2007
+Linux version 2.6.24-rc5 (parag@pavillion.hsd1.mi.comcast.net) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14)) #2 SMP Wed Dec 19 11:32:37
EST 2007
 Linux video capture interface: v2.00
 lo: Disabled Privacy Extensions
 lp: driver loaded but no devices found
@@ -450,7 +448,7 @@ TCP bind hash table entries: 65536 (orde
 TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
 TCP: Hash tables configured (established 262144 bind 65536)
 TCP reno registered
-time.c: Detected 2199.952 MHz processor.
+time.c: Detected 2199.958 MHz processor.
 Time: tsc clocksource has been installed.
 Total HugeTLB memory allocated, 0
 TSC calibrated against HPET


Parag
