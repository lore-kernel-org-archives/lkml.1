Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbZAQWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbZAQWIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbZAQWIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:08:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47435 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbZAQWIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t2GBRaYGcgnJ48FlRz0718cjw6gZKDsZ298+QH0Cd3P1usN4qApif9QvGUaxJVGDhV
         QMfiRPadfFNOoZbWyiWOyJwjgPitgdzOh9R8AG5WmRSF5OQbADTuwGPA66yWAXuUU7Gg
         s78WrqOm7vUPV9jC3NjVacAshtnnSYVCQbBMU=
Subject: Re: kernel 2.6.28 XFS internal error xfs_da_do_buf(2) at line 2112
 of	file fs/xfs/xfs_da_btree.c
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
In-Reply-To: <4972484E.5030204@sandeen.net>
References: <1232225359.8845.198.camel@champagne.cantina>
	 <4972484E.5030204@sandeen.net>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 23:08:03 +0100
Message-Id: <1232230083.8845.220.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 15:06 -0600, Eric Sandeen wrote:
> Alessandro Bono wrote:
> > Hi all
> > 
> > New kernel new problem
> > rsync over ssh to a usb disk get this scary message
> > 
> > Jan 17 17:39:50 champagne kernel: [30342.675488] 00000000: e8 1f 67 a1
> > 7f 9c 65 fc c7 e9 c7 3f e1 d7 17 a7  ..g...e....?....
> > Jan 17 17:39:50 champagne kernel: [30342.675504] Filesystem "sdb1": XFS
> > internal error xfs_da_do_buf(2) at line 2112 of file
> > fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0196e9f
> 
> This means that it read metadata with a bad magic number (the message
> could be clearer).
> 
> Any storage errors in dmesg prior to this?

In effect there is this message
Jan 17 17:39:49 champagne kernel: [30342.273029] usb 4-3: reset high
speed USB device using ehci_hcd and address 4

I was using a usb pen that I disconnected just a second prior errors
appear, for some reason plugging out usb pen caused a reset on usb disk
(two port located on two side on my notebook, I didn't touch usb disk
while disconnecting usb pen)

Jan 17 17:34:47 champagne kernel: [30039.760046] usb 4-5: new high speed
USB device using ehci_hcd and address 5
Jan 17 17:34:47 champagne kernel: [30039.902828] usb 4-5: configuration
#1 chosen from 1 choice
Jan 17 17:34:47 champagne kernel: [30039.955770] scsi7 : SCSI emulation
for USB Mass Storage devices
Jan 17 17:34:47 champagne kernel: [30039.959464] usb-storage: device
found at 5
Jan 17 17:34:47 champagne kernel: [30039.959470] usb-storage: waiting
for device to settle before scanning
Jan 17 17:34:52 champagne kernel: [30044.956409] usb-storage: device
scan complete
Jan 17 17:34:52 champagne kernel: [30044.957497] scsi 7:0:0:0:
Direct-Access     USB      Driver           0.00 PQ: 0 ANSI: 0 CCS
Jan 17 17:34:52 champagne kernel: [30045.242137] sd 7:0:0:0: [sdc]
31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
Jan 17 17:34:52 champagne kernel: [30045.242644] sd 7:0:0:0: [sdc] Write
Protect is off
Jan 17 17:34:52 champagne kernel: [30045.242650] sd 7:0:0:0: [sdc] Mode
Sense: 23 00 00 00
Jan 17 17:34:52 champagne kernel: [30045.242655] sd 7:0:0:0: [sdc]
Assuming drive cache: write through
Jan 17 17:34:52 champagne kernel: [30045.249520] sd 7:0:0:0: [sdc]
31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
Jan 17 17:34:52 champagne kernel: [30045.250007] sd 7:0:0:0: [sdc] Write
Protect is off
Jan 17 17:34:52 champagne kernel: [30045.250013] sd 7:0:0:0: [sdc] Mode
Sense: 23 00 00 00
Jan 17 17:34:52 champagne kernel: [30045.250018] sd 7:0:0:0: [sdc]
Assuming drive cache: write through
Jan 17 17:34:52 champagne kernel: [30045.250028]  sdc: sdc1
Jan 17 17:34:52 champagne kernel: [30045.250863] sd 7:0:0:0: [sdc]
Attached SCSI removable disk
Jan 17 17:34:52 champagne kernel: [30045.251074] sd 7:0:0:0: Attached
scsi generic sg3 type 0
Jan 17 17:39:49 champagne kernel: [30342.166347] usb 4-5: USB
disconnect, address 5
Jan 17 17:39:49 champagne kernel: [30342.273029] usb 4-3: reset high
speed USB device using ehci_hcd and address 4

Is this a usb problem? 

thanks Eric

> 
> -Eric
-- 
---
Cordiali Saluti
Alessandro Bono

