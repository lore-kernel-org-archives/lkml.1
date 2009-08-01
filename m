Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZHAWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZHAWfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZHAWft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:35:49 -0400
Received: from th5.kapitza.ras.ru ([83.149.229.88]:43165 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752417AbZHAWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:35:49 -0400
X-Greylist: delayed 729 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Aug 2009 18:35:48 EDT
Date: Sun, 2 Aug 2009 02:23:43 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: reading errors on JMicron JM20337 USB-SATA
Message-ID: <alpine.LFD.2.00.0908020135100.15267@nev.ubzr>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have read through a year old thread on "JMicron JM20337 USB-SATA data 
corruption bugfix" and it seems here's another aspect of the same problem. 
The SATA disk has genuine errors (bad sectors, just in case: I am not 
going to use it but to recover some data from it). Unfortunately when a 
bad block is read no error is returned, instead a caller is blocked 
indefinitely (until the USB cable is removed). The system log is filled 
with repetitive

sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0

Is this difficult/possible to fix?

The kernel is 2.6.27.28, here's what I get with CONFIG_USB_STORAGE_DEBUG 
set:

usb-storage: Status code -121; transferred 0/4096
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x39 R 4096 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x3a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
usb-storage: (Unknown Key): (unknown ASC/ASCQ)
usb-storage: scsi cmd done, result=0x2
sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0
usb-storage: queuecommand called
usb-storage: *** thread sleeping.
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 03 a8 d0 b0 00 00 08 00
usb-storage: Bulk Command S 0x43425355 T 0x3b L 4096 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries

I'd be glad to supply additional information if needed.
Thanks
-L
