Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbZD0Uut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbZD0Uut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZD0Uuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:50:37 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:22237 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZD0Uug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:50:36 -0400
Message-ID: <49F61A99.1000209@billgatliff.com>
Date: Mon, 27 Apr 2009 15:50:33 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: usb 1-1: reset full speed USB device using ep93xx-ohci and address
 2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:


I'm getting this problem all the time on an ep93xx platform (ARM, 
ts-7260) when I use a USB flash device as the root filesystem.  The 
kernel is a slightly-modified 2.6.27:

...
INIT: version 2.86 booting
usb 1-1: reset full speed USB device using ep93xx-ohci and address 2
usb 1-1: reset full speed USB device using ep93xx-ohci and address 2
usb 1-1: device descriptor read/64, error -110
usb 1-1: device descriptor read/64, error -110
...

Google tells me that this problem has come and gone for quite a while, 
but it's currently present for me nearly 100% of the time.

One thing that I find interesting is that the very same device that 
produced the above messages works absolutely fine on the very same 
hardware and kernel when it isn't being used as a root filesystem 
device.  In fact, I've been abusing the device for a couple of days now 
with no problems, where when used as a normal rootfs it dies almost 
immediately after sysvinit starts up.

What's equally troubling is the fact that a few weeks ago, this same 
device with the very same hardware worked without problems, then seemed 
to progressively get worse until now it's virtually unusable due to the 
high number of USB reset events.  But I don't think in this case it's a 
hardware degradation problem; rather, I'm suspicious that system use has 
changed something in the access patterns to the device (timing or 
otherwise) that expose a latent problem.

The filesystem is ext3, and it's a 1GB USB 2.0 flash device  I've tried 
mounting it with noatime, that doesn't seem to help--- while in use as a 
rootfs I get the same pattern of reset messages as described above, and 
when not used as a rootfs operation is still error-free.  My "other" 
rootfs is NFS, populated from the contents of the USB device itself.

I'm stumped, and I'm hoping this machine will help provide someone with 
information needed to lick this problem as it's preventing me from 
deploying some important functionality.

I rarely see problems before the "INIT: version 2.86 booting" message 
above.  Is it possible that there's something related to the fact that 
the device is read-only prior to that?

My test script used when the USB device isn't the rootfs looks like this:

    while true; do rm -f /mnt/randomfile*; dd if=/dev/urandom
        of=/mnt/randomfile bs=1024 count=20480;
        tar cf /mnt/randomfile.tar /mnt/randomfile; date; done


Hoping someone can help me shed some light on this,


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

