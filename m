Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYICQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYICQ7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYICQ7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:59:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbYICQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:59:12 -0400
Date: Wed, 3 Sep 2008 09:53:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott Pitcher <scottpitcher@netspace.net.au>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
Message-Id: <20080903095359.27961778.akpm@linux-foundation.org>
In-Reply-To: <loom.20080902T014408-4@post.gmane.org>
References: <loom.20080902T014408-4@post.gmane.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

On Tue, 2 Sep 2008 01:45:05 +0000 (UTC) Scott Pitcher <scottpitcher@netspace.net.au> wrote:

> Hi,
> 
> I have installed a Pioneer DVD burner (DVR-215) in my system. The mother board
> is an Asus only 6 months old. Basically the drive is detected by the system but
> sata_via complains and generates some errors in the log and then the drive will
> not work after this. I was running kernel 2.6.25.4, and upgraded to 2.6.26.3 but
> this did not fix the problem. The following is the output from dmesg ....
> 
> dmesg ...
> [ 1385.859656] sata_via 0000:00:0f.0: version 2.3
> [ 1385.859656] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low)
>  -> IRQ 21
> [ 1385.859656] sata_via 0000:00:0f.0: routed to hard irq line 5
> [ 1385.859656] scsi1 : sata_via
> [ 1385.863725] scsi2 : sata_via
> [ 1385.863817] ata1: SATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 
> irq 21
> [ 1385.863930] ata2: SATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 
> irq 21
> [ 1386.066384] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 1386.267532] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.19, max UDMA/66
> [ 1386.283554] ata1.00: configured for UDMA/66
> [ 1386.487712] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
> [ 1386.493386] scsi scan: 96 byte inquiry failed.  Consider BLIST_INQUIRY_36
>  for this device
> [ 1386.495598] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215
>   1.19 PQ: 0 ANSI: 5
> [ 1386.545213] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 
> cdda tray
> [ 1386.545213] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [ 1386.545213] sr 1:0:0:0: Attached scsi generic sg4 type 5
> [ 1418.220235] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [ 1418.220251] ata1.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [ 1418.220253]          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> [ 1418.220255]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 
> 0x4 (timeout)
> [ 1418.220259] ata1.00: status: { DRDY }
> [ 1423.492058] ata1: link is slow to respond, please be patient (ready=0)
> [ 1428.644051] ata1: soft resetting link
> [ 1434.040372] ata1: link is slow to respond, please be patient (ready=0)
> [ 1439.050298] ata1: SRST failed (errno=-16)
> [ 1439.050420] ata1: soft resetting link
> [ 1444.410358] ata1: link is slow to respond, please be patient (ready=0)
> [ 1449.437825] ata1: SRST failed (errno=-16)
> [ 1449.437837] ata1: soft resetting link
> [ 1454.832725] ata1: link is slow to respond, please be patient (ready=0)
> [ 1485.752921] ata1: SRST failed (errno=-16)
> [ 1485.753068] ata1: soft resetting link
> [ 1491.035430] ata1: SRST failed (errno=-16)
> [ 1491.035439] ata1: reset failed, giving up
> [ 1491.035443] ata1.00: disabled
> [ 1491.035458] ata1: EH complete
> 
> The following is the output from lspci ...
> bash-3.1# lspci
> 00:00.0 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:00.1 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:00.2 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:00.3 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:00.4 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:00.5 PIC: VIA Technologies, Inc. P4M900 I/O APIC Interrupt Controller
> 00:00.6 Host bridge: VIA Technologies, Inc. P4M900 Security Device
> 00:00.7 Host bridge: VIA Technologies, Inc. P4M900 Host Bridge
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237/VX700 PCI Bridge
> 00:02.0 PCI bridge: VIA Technologies, Inc. P4M900 PCI to PCI Bridge 
>  Controller(rev 80)
> 00:03.0 PCI bridge: VIA Technologies, Inc. P4M900 PCI to PCI
>  Bridge Controller (rev 80)
> 00:0f.0 IDE interface: VIA Technologies, Inc. Unknown device 5372
> 00:0f.1 IDE interface: VIA Technologies, Inc.
>  VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI 
>  USB 1.1 Controller (rev b0)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI 
>  USB 1.1 Controller (rev b0)
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI 
>  USB 1.1 Controller (rev b0)
> 00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI 
>  USB 1.1 Controller (rev b0)
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 90)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237S PCI to ISA Bridge
> 00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 7c)
> 00:13.0 Host bridge: VIA Technologies, Inc. VT8237A Host Bridge
> 00:13.1 PCI bridge: VIA Technologies, Inc. VT8237A PCI to PCI Bridge
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. P4M900
>  [Chrome 9 HC] (rev 01)
> 04:05.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 
>  1394 OHCI Link Layer Controller (rev 46)
> 80:01.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] 
>  (VIA High Definition Audio Controller) (rev 10)
> 
> And lspci -n ....
> 
> 00:00.0 0600: 1106:0364
> 00:00.1 0600: 1106:1364
> 00:00.2 0600: 1106:2364
> 00:00.3 0600: 1106:3364
> 00:00.4 0600: 1106:4364
> 00:00.5 0800: 1106:5364
> 00:00.6 0600: 1106:6364
> 00:00.7 0600: 1106:7364
> 00:01.0 0604: 1106:b198
> 00:02.0 0604: 1106:a364 (rev 80)
> 00:03.0 0604: 1106:c364 (rev 80)
> 00:0f.0 0101: 1106:5372
> 00:0f.1 0101: 1106:0571 (rev 07)
> 00:10.0 0c03: 1106:3038 (rev b0)
> 00:10.1 0c03: 1106:3038 (rev b0)
> 00:10.2 0c03: 1106:3038 (rev b0)
> 00:10.3 0c03: 1106:3038 (rev b0)
> 00:10.4 0c03: 1106:3104 (rev 90)
> 00:11.0 0601: 1106:3372
> 00:11.7 0600: 1106:287e
> 00:12.0 0200: 1106:3065 (rev 7c)
> 00:13.0 0600: 1106:337b
> 00:13.1 0604: 1106:337a
> 01:00.0 0300: 1106:3371 (rev 01)
> 04:05.0 0c00: 1106:3044 (rev 46)
> 80:01.0 0403: 1106:3288 (rev 10)
> 
> And uname -a ...
> 
> bash-3.1# uname -a
> Linux officepc 2.6.26.3-A #2 SMP PREEMPT Sat Aug 30 17:56:11 EST 2008 
> i686 Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz GenuineIntel GNU/Linux
> 
> Any help would be appreciated.
> 

