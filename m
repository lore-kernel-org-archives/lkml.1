Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbYKAGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbYKAGso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYKAGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 02:48:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbYKAGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 02:48:31 -0400
Date: Fri, 31 Oct 2008 23:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
Message-Id: <20081031234823.5064dd88.akpm@linux-foundation.org>
In-Reply-To: <1225344169.17253.43.camel@localhost>
References: <1225344169.17253.43.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On Thu, 30 Oct 2008 06:22:49 +0100 Kasper Sandberg <lkml@metanurb.dk> wrote:

> Hello..
> 
> I had to write an image to some usb flash drives, more specifically, 4GB
> kingston datatraveler sticks, and i figured, instead of doing just 1 at
> a time, i may aswell do 4, so i plugged in 4, and started 4 dd's of the
> images, to sdc, sdd, sde, sdf. However, i got usb disconnects and IO
> error messages from the kernel, these are at end of message. I had
> previously done ~5 writes of images to 5 other flash disks with no
> problem, but when i tried the next batch, those 4, it gave these errors.
> I killed the dd's, pulled them all out, and put in 1 at a time, and it
> worked perfectly.
> 
> unfortunately the first kernel messages have been flooded away. If you
> need .config and/or the boot kernel messages, i can reboot and get it.
> 
> this is on ICH9 ehci, from lspci:
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #5 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #6 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #2 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #1 (rev 02)
> 
> 
> and the messages:
> usb 8-6: new high speed USB device using ehci_hcd and address 17
> usb 8-6: configuration #1 chosen from 1 choice
> scsi24 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 17
> usb-storage: waiting for device to settle before scanning
> scsi 24:0:0:0: Direct-Access     Kingston DataTraveler 2.0 PMAP PQ: 0
> ANSI: 0 CCS
> sd 24:0:0:0: [sdc] 7936000 512-byte hardware sectors (4063 MB)
> sd 24:0:0:0: [sdc] Write Protect is off
> sd 24:0:0:0: [sdc] Mode Sense: 23 00 00 00
> sd 24:0:0:0: [sdc] Assuming drive cache: write through
> sd 24:0:0:0: [sdc] 7936000 512-byte hardware sectors (4063 MB)
> sd 24:0:0:0: [sdc] Write Protect is off
> sd 24:0:0:0: [sdc] Mode Sense: 23 00 00 00
> sd 24:0:0:0: [sdc] Assuming drive cache: write through
>  sdc: sdc1
> sd 24:0:0:0: [sdc] Attached SCSI removable disk
> usb-storage: device scan complete
> usb 8-5: new high speed USB device using ehci_hcd and address 18
> usb 8-5: configuration #1 chosen from 1 choice
> scsi25 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 18
> usb-storage: waiting for device to settle before scanning
> scsi 25:0:0:0: Direct-Access     Kingston DataTraveler 2.0 PMAP PQ: 0
> ANSI: 0 CCS
> sd 25:0:0:0: [sdd] 7936000 512-byte hardware sectors (4063 MB)
> sd 25:0:0:0: [sdd] Write Protect is off
> sd 25:0:0:0: [sdd] Mode Sense: 23 00 00 00
> sd 25:0:0:0: [sdd] Assuming drive cache: write through
> sd 25:0:0:0: [sdd] 7936000 512-byte hardware sectors (4063 MB)
> sd 25:0:0:0: [sdd] Write Protect is off
> sd 25:0:0:0: [sdd] Mode Sense: 23 00 00 00
> sd 25:0:0:0: [sdd] Assuming drive cache: write through
>  sdd: sdd1
> sd 25:0:0:0: [sdd] Attached SCSI removable disk
> usb-storage: device scan complete
> usb 7-2: new high speed USB device using ehci_hcd and address 6
> usb 7-2: configuration #1 chosen from 1 choice
> scsi26 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 6
> usb-storage: waiting for device to settle before scanning
> scsi 26:0:0:0: Direct-Access     Kingston DataTraveler 2.0 PMAP PQ: 0
> ANSI: 0 CCS
> sd 26:0:0:0: [sde] 7936000 512-byte hardware sectors (4063 MB)
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 23 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> sd 26:0:0:0: [sde] 7936000 512-byte hardware sectors (4063 MB)
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 23 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
>  sde: sde1
> sd 26:0:0:0: [sde] Attached SCSI removable disk
> usb-storage: device scan complete
> usb 7-1: new high speed USB device using ehci_hcd and address 7
> usb 7-1: configuration #1 chosen from 1 choice
> scsi27 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 7
> usb-storage: waiting for device to settle before scanning
> scsi 27:0:0:0: Direct-Access     Kingston DataTraveler 2.0 PMAP PQ: 0
> ANSI: 0 CCS
> sd 27:0:0:0: [sdf] 7936000 512-byte hardware sectors (4063 MB)
> sd 27:0:0:0: [sdf] Write Protect is off
> sd 27:0:0:0: [sdf] Mode Sense: 23 00 00 00
> sd 27:0:0:0: [sdf] Assuming drive cache: write through
> sd 27:0:0:0: [sdf] 7936000 512-byte hardware sectors (4063 MB)
> sd 27:0:0:0: [sdf] Write Protect is off
> sd 27:0:0:0: [sdf] Mode Sense: 23 00 00 00
> sd 27:0:0:0: [sdf] Assuming drive cache: write through
>  sdf: sdf1
> sd 27:0:0:0: [sdf] Attached SCSI removable disk
> usb-storage: device scan complete
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sde, sector 216960
> Buffer I/O error on device sde, logical block 27120
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27121
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27122
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27123
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27124
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27125
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27126
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27127
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 27128
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sde, sector 217200
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 97148 callbacks suppressed
> Buffer I/O error on device sde, logical block 124277
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124278
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124279
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124280
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124281
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124282
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124283
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124284
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124285
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 124286
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 152257 callbacks suppressed
> Buffer I/O error on device sde, logical block 276544
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276545
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276546
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276547
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276548
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276549
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276550
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276551
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276552
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 276553
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 170419 callbacks suppressed
> Buffer I/O error on device sde, logical block 446973
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446974
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446975
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446976
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446977
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446978
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446979
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446980
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446981
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 446982
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 152214 callbacks suppressed
> Buffer I/O error on device sde, logical block 599197
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599198
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599199
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599200
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599201
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599202
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599203
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599204
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599205
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 599206
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 165606 callbacks suppressed
> Buffer I/O error on device sde, logical block 764813
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764814
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764815
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764816
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764817
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764818
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764819
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764820
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764821
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 764822
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> __ratelimit: 165555 callbacks suppressed
> Buffer I/O error on device sde, logical block 930378
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930379
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930380
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930381
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930382
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930383
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930384
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930385
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930386
> lost page write due to I/O error on sde
> Buffer I/O error on device sde, logical block 930387
> lost page write due to I/O error on sde
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-1: USB disconnect, address 7
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 8-5: USB disconnect, address 18
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: reset high speed USB device using ehci_hcd and address 6
> usb 7-2: USB disconnect, address 6
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x07 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> sd 26:0:0:0: [sde] READ CAPACITY failed
> sd 26:0:0:0: [sde] Result: hostbyte=0x01 driverbyte=0x00
> sd 26:0:0:0: [sde] Sense not available.
> sd 26:0:0:0: [sde] Write Protect is off
> sd 26:0:0:0: [sde] Mode Sense: 00 00 00 00
> sd 26:0:0:0: [sde] Assuming drive cache: write through
> usb 8-6: USB disconnect, address 17
> 
> 
> mvh.
> Kasper Sandberg
> 

