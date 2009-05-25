Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZEYOAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZEYOAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZEYOAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:00:42 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34289 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZEYOAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:00:41 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
References: <20090525125736.GA5582@redhat.com>
Date: Mon, 25 May 2009 23:00:39 +0900
In-Reply-To: <20090525125736.GA5582@redhat.com> (Michael S. Tsirkin's message
	of "Mon, 25 May 2009 15:57:36 +0300")
Message-ID: <87y6slb7ug.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> An attempt to mount it under linux 2.6.30-rc7 results in these messages:
>
> usb 1-3: new high speed USB device using ehci_hcd and address 7
> usb 1-3: New USB device found, idVendor=090c, idProduct=6000
> usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-3: Product: USB2.0 Card Reader  
> usb 1-3: Manufacturer: Generic       ,   . 
> usb 1-3: SerialNumber: 0000001       
> usb 1-3: configuration #1 chosen from 1 choice
> Initializing USB Mass Storage driver...
> scsi2 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 7
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 2:0:0:0: Direct-Access     Generic                   6000 PQ: 0 ANSI: 0 CCS
> sd 2:0:0:0: Attached scsi generic sg2 type 0
> sd 2:0:0:0: [sdb] 990976 512-byte hardware sectors: (507 MB/483 MiB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 4b 00 00 08
> sd 2:0:0:0: [sdb] Assuming drive cache: write through
> sd 2:0:0:0: [sdb] Assuming drive cache: write through
>  sdb:<6>sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 2:0:0:0: [sdb] Sense Key : Illegal Request [current] 
> sd 2:0:0:0: [sdb] Add. Sense: Logical block address out of range
> end_request: I/O error, dev sdb, sector 0
> Buffer I/O error on device sdb, logical block 0
> Dev sdb: unable to read RDB block 0
>  unable to read partition table
> sd 2:0:0:0: [sdb] Attached SCSI removable disk
> usb 1-3: USB disconnect, address 7
>
> parted seems to display both partitions just fine,
> and that other OS does not seem to have any trouble
> accessing the disk.
>
> The message 'unable to read RDB block' seems to come from
> fs/partitions/amiga.c which looks pretty weird.
>
> Any idea what info would be helpful in debugging this?
> Just to clarify, this is not a regression - older linux versions
> as far back as 2.6.24 seem to behave the same way.

It seems I/O error happened while checking the partition types (sector 0).
I guess usb people may have knowledge of this. CC to linux-usb.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
