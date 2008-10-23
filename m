Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYJWTWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYJWTWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYJWTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:22:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:38911 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYJWTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:22:40 -0400
Message-ID: <ac3eb2510810231222t4fe0f8bel2abd83e77b8471b7@mail.gmail.com>
Date: Thu, 23 Oct 2008 21:22:39 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Help: undesired 10 seconds delay in creating USB devices
Cc: "Gu, Mingkun" <Mingkun.Gu@gtech.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081023161355.GA8171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023152216.GA3911@kroah.com>
	 <32C88E5279F5DD46B7237443CD61E67901E455BA@cspmail02.gtk.gtech.com>
	 <20081023161355.GA8171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 18:13, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 23, 2008 at 01:11:00PM -0300, Gu, Mingkun wrote:

>> [MKGU>] My device driver name is "usbled". Our USB device has
>> VendorID=11b4. After I unplugged the USB cable connecting to this device
>> and kept the device driver "usbled" remaining loaded, I plugged in the
>> USB cable back to the system again. I could see the device information
>> retrieved from /proc/bus/usb/devices immediately but the device name
>> /dev/usbled0 was seen after near 10 seconds.
>
> That sounds like a udev script issue, not a kernel issue, correct?
>
>> > If you run 'udevadm monitor', does it show a 10 second delay?
>>
>> [MKGU>] I don't have the program 'udevadm' on my system.
>
> Do you have the program 'udevmonitor'?  I suggest trying that.

2.6.21.7 (man, these silly numbers, no idea why people want to keep
them :)) should not be affected, as far as I know, but recent kernels
might need a one-line fix to a (broken) udev rule, no to delay
handling of some scsi devices, and wait at the wrong device for a
sysfs file which will never appear. You can try commenting out a rule
in /etc/udev/rules.d/*.rules, which has WAIT_FOR_SYSFS="ioerr_cnt" or
similar.

Kay
