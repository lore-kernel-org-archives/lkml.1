Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXLQBOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXLQBOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbXLQBOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:14:15 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:57051 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755821AbXLQBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BoaqYdONQeyCRoayhvykmhoqe1acBHUxie9EDKookyc7pVQBo0gAGCAyYcoTe7kHzLWX0q3LLiHdZScQteSNq63G9R24+b015ubthBbI7OqNcPnIBcdHBH5HwlfC8YQ+0zv3GMSAVjd4VlRHbdOHpxNuMEGNx2M4xX3DSj+ChAo=
Message-ID: <a8e1da0712161714w23998e49q6e30ffe8d46db0dd@mail.gmail.com>
Date: Mon, 17 Dec 2007 09:14:12 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: 2.6.24-rc5-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mdharm-usb@one-eyed-alien.net, gregkh@suse.de,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0712141039050.4768-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0712132132t6bcef833vc492e4164c22705a@mail.gmail.com>
	 <Pine.LNX.4.44L0.0712141039050.4768-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 11:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 Dec 2007, Dave Young wrote:
>
> > Hi,
> > The behaviour of my mp3 player (also act as usb-storage device) seems
> > changed from rc5 to rc5-mm1.
>
> This can't be considered a bug, right?

I'm not sure.

> It's just that the player
> changed from one slightly non-standard behavior to a different slightly
> non-standard behavior.
>
>
> > <dmesg output under rc5>:
> > =========
> > usb 1-7: new high speed USB device using ehci_hcd and address 7
> > usb 1-7: configuration #1 chosen from 1 choice
> > scsi4 : SCSI emulation for USB Mass Storage devices
> > usb-storage: device found at 7
> > usb-storage: waiting for device to settle before scanning
> > scsi 4:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
> > sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 4:0:0:0: [sdb] Write Protect is on
> > sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
> > sd 4:0:0:0: [sdb] Assuming drive cache: write through
> > sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 4:0:0:0: [sdb] Write Protect is on
> > sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
> > sd 4:0:0:0: [sdb] Assuming drive cache: write through
> >  sdb: sdb1
> > sd 4:0:0:0: [sdb] Attached SCSI removable disk
> > sd 4:0:0:0: Attached scsi generic sg1 type 0
> > usb-storage: device scan complete
> >
> > ==========
> > try mount it (or just blockdev --rereadpt), then write protect become off:
> > ==========
> >
> > sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 4:0:0:0: [sdb] Write Protect is off
> > sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
> > sd 4:0:0:0: [sdb] Assuming drive cache: write through
> > sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 4:0:0:0: [sdb] Write Protect is off
> > sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
> > sd 4:0:0:0: [sdb] Assuming drive cache: write through
> >  sdb: sdb1
>
> This output won't appear if you simply mount the device.  So how do you
> know that mounting turns off write protect?

This can be observed by eye:
dmesg -> mount -> dmesg

>
> > But under rc5-mm1, after mount command being executed, it is just
> > mouted as read only partition without set the write-protect to off
> >
> > I tried "blockdev --rereadpt", it do set the write-protect to off as rc5 kernel.
> >
> > Below is the output of dmesg under rc5-mm1
> > ==========
> > usb 1-8: new high speed USB device using ehci_hcd and address 6
> > usb 1-8: configuration #1 chosen from 1 choice
> > scsi3 : SCSI emulation for USB Mass Storage devices
> > usb-storage: device found at 6
> > usb-storage: waiting for device to settle before scanning
> > scsi 3:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
> > sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 3:0:0:0: [sdb] Write Protect is on
> > sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
> > sd 3:0:0:0: [sdb] Assuming drive cache: write through
> > sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> > sd 3:0:0:0: [sdb] Write Protect is on
> > sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
> > sd 3:0:0:0: [sdb] Assuming drive cache: write through
> >  sdb: sdb1
>
> This looks exactly the same as the output above (except for various
> port, device, and bus numbers).

Yes, but lacks the part of "'Write Protect if off'  and other lines".

>
> If you turn on CONFIG_USB_STORAGE_DEBUG for both kernels and compare
> the dmesg output for the mount command, that might highlight the
> difference.

Ok, I will test with do once have time, thanks.

Regards
dave
