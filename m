Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZALWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZALWTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZALWTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:19:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3568 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752006AbZALWTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:19:05 -0500
Date: Mon, 12 Jan 2009 17:19:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: A really interesting mass-storage BUG introduced after 2.6.18
In-Reply-To: <4969DAF3.70409@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0901121717520.13021-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, [UTF-8] Ozan Çağlayan wrote:

> Hi,
> 
> One of our users reported[0] that his 128MB mass storage driver doesn't 
> work anymore on our current stock kernel 2.6.25.20 by hotplugging but 
> works flawlessly if it was plugged before booting the OS. He also said 
> that it was working out of the box with our old kernel 2.6.18. I 
> gathered a lot of output and debugging stuff from the user[1][2] and 
> found out that the device has some problems with SCSI Inquiry commands 
> then I discovered the patch of Alan Stern about the bad residue 
> values[3], backported it and no way it didn't solve the problem.
> 
> I also suggested to give a try to the current stable 2.6.28 but the 
> behaviour is still the same.
> 
> When hotplugged, the kernel doesn't detect the partitions in the device 
> leaving the block device on its own but if it's plugged during the boot, 
> the partitions are correctly detected and have their own /sys/block 
> entries. Note that the device reports a "usb embedded hub" beside a mass 
> storage device (dunno if it's the case with all of these kind devices).
> 
> [0]: http://bugs.pardus.org.tr/show_bug.cgi?id=8369
> [1]: http://bugzilla.kernel.org/show_bug.cgi?id=11125
> [2]: http://bugs.pardus.org.tr/attachment.cgi?id=3553 (Hotplugged dmesg 
> output)
> [3]: http://bugs.pardus.org.tr/attachment.cgi?id=3561 (Coldplug dmesg 
> output, correctly detected)

Please ask Antoon to collect a usbmon log during a hotplug test.  The 
instructions are in Documentation/usb/usbmon.txt.

Alan Stern

