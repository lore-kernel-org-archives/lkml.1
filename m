Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbXFCM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbXFCM3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbXFCM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:29:36 -0400
Received: from lucidpixels.com ([75.144.35.66]:45747 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbXFCM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:29:36 -0400
Date: Sun, 3 Jun 2007 08:29:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Oliver Neukum <oneukum@suse.de>
cc: linux-usb-devel@lists.sourceforge.net, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <200706031254.52434.oneukum@suse.de>
Message-ID: <Pine.LNX.4.64.0706030828460.3790@p34.internal.lan>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan> <200706031254.52434.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Oliver Neukum wrote:

> Am Sonntag, 3. Juni 2007 12:36 schrieb Justin Piszcz:
>>
>> On Sun, 3 Jun 2007, Jiri Kosina wrote:
>>
>>> On Sat, 2 Jun 2007, Justin Piszcz wrote:
>
>>>> failed to claim USB device, trying 2 more time(s)...
>>>> detaching kernel driver from USB device...
>>>
>>> Could you please provide strace outputs (or put it on the web somewhere if
>>> it's too big) for the failing and succeeding claiming of the device?
>
> static int usbdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> {
> 	struct dev_state *ps = file->private_data;
> 	struct usb_device *dev = ps->dev;
> 	void __user *p = (void __user *)arg;
> 	int ret = -ENOTTY;
>
> 	if (!(file->f_mode & FMODE_WRITE))
> 		return -EPERM;
>
> That check fails as your application falls back to opening read only in
> case of insufficient permissions. Did you change some udev rules?
>
> 	Regards
> 		Oliver
>

Nope and just to verify that I made sure I tested this a couple times. 
Booted 2.6.21.3 no problems, then booted 2.6.23-rc3 w/out your patch, 
problem happens again.

Justin.
