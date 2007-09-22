Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXIVOKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXIVOKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXIVOJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:09:59 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:58873 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbXIVOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:09:59 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Sep 2007 10:09:58 EDT
Message-ID: <46F52012.5050902@hhs.nl>
Date: Sat, 22 Sep 2007 16:00:50 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive
 leds
References: <Pine.LNX.4.44L0.0709211032200.4167-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709211032200.4167-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> The correct answer is that HAL should top polling while the device is 
> suspended.
> 
> In kernels starting with 2.6.23-rc6, the correct way to enable 
> autosuspend for a USB device is basically like this:
> 
> 	echo D >/sys/bus/usb/devices/.../power/autosuspend
> 	echo auto >/sys/bus/usb/devices/.../power/level
> 

I'm afraid that that doesn't work for usb mass-storage devices.

Here is what I did:
1) kill hal
2) insert usb stick -> led lights
3):
echo -n 1 >    /sys/bus/usb/devices/.../power/autosuspend
echo -n auto > /sys/bus/usb/devices/.../power/level

4) wait

Nothing happens, where as sending "suspend" to power/level does turn the led 
off. Now call me naive, but I would expect a mass-storage devices with no 
partitions mounted to autosuspend when autosuspend is enabled for that device.

And yes I'm pretty sure nothing else is talking to the device.

As usual keep please me CC-ed as I'm not on the list.

Regards,

Hans
