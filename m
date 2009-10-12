Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbZJLLq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbZJLLq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZJLLq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:46:57 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:29172 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZJLLq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:46:56 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AD31709.4000103@tremplin-utc.net>
Date: Mon, 12 Oct 2009 13:46:17 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Dmitry Torokhov <dtor@insightbb.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work anymore
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com>
In-Reply-To: <200910112135.29384.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-10-09 06:35, Dmitry Torokhov schreef:
> On Saturday 10 October 2009 08:00:29 pm Greg KH wrote:
>> On Sun, Oct 11, 2009 at 02:04:02AM +0200, ?ric Piel wrote:
>>> Hello,
>>>
>>> After a suspend, I used to do this (to get the PS2 keyboard working
>>> again), and it used to work fine:
>>> echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind ; sleep 1 ; echo
>>> -n "i8042" > /sys/bus/platform/drivers/i8042/bind
>>>
>>> Unfortunately since 2.6.32-rc1, the unbind works fine, but the bind
>>> returns a "no such device" error now (and the binding is not done). After
>>> that, additional unbinds also report the error. I think 2.6.31 worked
>>> fine. Any idea what's going wrong?
>> Odd.  Any chance you can run 'git bisect' to figure out which patch
>> might have caused it?
> 
> I8042 has been converted to use platform_driver_probe() - we are creating 
> platform device and platform driver together, there is no chance that some 
> other device might be driven by i8042 driver.
I haven't finished bisecting, but indeed, the problem seemed to converge
toward this patch.


> Eric, do you still need to fiddle with i8042 to get your keyboard working with 
> 2.6.32-rc3? We need to make sure that resube works without users needing to 
> mess with bind/unbind.
Yes, the keyboard doesn't work after the first resume from ram (the
later resumes do work). I haven't tried any special option to the i8042
driver. This is on a HP 2510, in 64 bits.

Indeed, it would be great to fix this root problem! Is there any bug
report opened to work on this?

However, currently the first problem is that unbind works, while bind
doesn't. Which means anyone doing an unbind will have keyboard and mouse
lost until the next reboot. That's rather bad because it has been
recommended for a long time to have this kind of script at resume:
http://intertrusion.com/files/hp-s2ram.patch
http://en.opensuse.org/Pm-utils

So at least, unbind should fail as well as bind.

Eric
