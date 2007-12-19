Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbXLSQHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbXLSQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXLSQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:07:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59981 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752196AbXLSQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:07:07 -0500
Date: Wed, 19 Dec 2007 11:07:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <mdharm-usb@one-eyed-alien.net>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: 2.6.24-rc5-mm1
In-Reply-To: <a8e1da0712182349k34926f55o1a667a65e925c84a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712191042460.4277-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Dave Young wrote:

> I tested on another machine with kernel 2.6.24-rc2. And the result is
> diffrent again.
> Here is the result:
> 
> 1. on 2.6.24-rc2, when I plugin the player the kernel reports below messages:
> 
> usb-storage: waiting for device to settle before scanning
> /*[lets mark the below part as part 1]*/
> scsi 0:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
> sd 0:0:0:0: [sda] 245248 512-byte hardware sectors (126 MB)
> sd 0:0:0:0: [sda] Write Protect is on
> sd 0:0:0:0: [sda] Mode Sense: 03 00 80 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 245248 512-byte hardware sectors (126 MB)
> sd 0:0:0:0: [sda] Write Protect is on
> sd 0:0:0:0: [sda] Mode Sense: 03 00 80 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> /*[lets mark the below part as part 2]*/
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> usb-storage: device scan complete
> sd 0:0:0:0: [sda] 245248 512-byte hardware sectors (126 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 245248 512-byte hardware sectors (126 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1

This is not normal.  When you plug in a storage device you should get 
all of the messages in your part 1 plus the first two lines in your 
part 2, but not the rest of part 2.

> 2. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> disk it reports the part 2 and mount the partition as rw
> 
> 3. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> disk it just mount the partition as ro with nothing more messages.

You must have a typo there.  Those can't both be true for 2.6.24-rc5.  
In fact you shouldn't see part 2 at all.

Here's what I get when I plug in a USB mass-storage device under 
2.6.24-rc5:

[   87.903014] usb-storage: device found at 2
[   87.909570] scsi 0:0:0:0: Direct-Access              Memorex TD 2B    1.09 PQ: 0 ANSI: 0 CCS
[   87.913144] usb-storage: device scan complete
[   88.804031] sd 0:0:0:0: [sda] 243712 512-byte hardware sectors (125 MB)
[   88.805507] sd 0:0:0:0: [sda] Write Protect is off
[   88.805577] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
[   88.805639] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   88.809526] sd 0:0:0:0: [sda] 243712 512-byte hardware sectors (125 MB)
[   88.810421] sd 0:0:0:0: [sda] Write Protect is off
[   88.810488] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
[   88.810575] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   88.810641]  sda: sda1
[   88.812450] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   89.041014] sd 0:0:0:0: Attached scsi generic sg0 type 0

Mounting the disk produces no extra output at all.  I get the same 
result under 2.6.23 and earlier operating systems.  You should see 
approximately the same thing.

Alan Stern

