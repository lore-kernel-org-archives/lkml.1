Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbYJSXH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbYJSXH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYJSXHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:07:49 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:13282 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYJSXHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:07:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -7.489
Message-ID: <48FBBDB7.50305@tremplin-utc.net>
Date: Mon, 20 Oct 2008 01:07:35 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <48FB6193.8090803@gmail.com>
In-Reply-To: <48FB6193.8090803@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron schreef:
> Hi Eric,
> 
> Nice looking driver. 
>> * Several people suggested to not put it in hwmon but in the future industrialio susbsystem: fine with that but as the industrialio subsystem is not available yet, it's still in hwmon with the other accelerometer drivers for now, and I'll happily move it whenever industrialio is integrated.
>>   
> Hmm.. might be a little while yet and there's still the debate on whether
> support for input subsystem is a good idea (different requirements etc).
> I'd be inclined to have a driver for this accelerometer in there, but the
> form it may be somewhat  different (for example, that datardy signal
> is vital in the sort of apps iio is designed for!)
> 
> Also, looking at the code, I'm not sure how similar things are to the
> equivalent i2c or spi interfaces.  Guess that'll only become entirely
> clear on implementation.
I'm hopeful it will be rather similar, but time will be judge ;-) I
believe the main difference in the driver requirement might not so much
come from the interface, but from the original reason someone put an
accelerometer in the system. It's in the laptops in order to detect
free-fall (for harddisk protection). It's in a phone in order to rotate
the screen when the phone is rotated. It's in the arm of a robot in
order to provide feedback on the motors. There are guys who just want to
use it to play neverball on their laptop. A generic accelerometer
subsystem will have to provide interfaces to comply to all the needs of
the usages, and should abstract the fact that several interfaces are
present from the driver.

> 
> I'll try and get an updated version of industrialio patches as is out later
> this week.
Great!

>> +Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>> +position - 3D position that the accelerometer reports. Format: "(x,y,z)"
>>   
> Hmm. Position? I've probably missed the debate on why it is called
> this.... 
Hehe, probably there has been no debate. I'm using the de-facto standard
defined by the hdaps driver. You can consider this as another incentive
to propose an official accelerometer subsystem ;-)


>> +/*
>> + * The sensor can also generate interrupts (DRDY) but it's pretty pointless
>> + * because their are generated even if the data do not change.
> Unless there is some serious filtering the noise level on such a chip
> will mean
> it almost always changes anyway.  However, for this type of app I can
> see your
> point!
Actually, when you leave the laptop without touching it in a calm
environment, the movement is very little and the detected changes are
around 1Hz. Anyway, the absolute reason that you cannot use the DRDY
interrupt is that if you use it, the free-fall and direction detection
are not usable anymore (interrupt cannot be shared).

See you,
Eric
