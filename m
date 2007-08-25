Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXHYKnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXHYKnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXHYKmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:42:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:9107 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXHYKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=J52fZmI9ImltxnbsVzGf/uDe9yTwwX7fzqdmP8XS3e9iZHfHi9TegRfRC/3MauAtm3ncHwU1twSGpDigYt3v7MN6PCjxAfTpI4PGAfheuAjmW1utaYbTA/zIze9rAc/RVZayNY7rdqnJ1YlR/OgWMsbDUtZrebQZcRrnYWaSETw=
Message-ID: <46D01420.3070400@gmail.com>
Date: Sat, 25 Aug 2007 13:36:00 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver (resend)
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz>
In-Reply-To: <20070825102512.GA5850@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2007-08-11 14:26:02, Yan Burman wrote:
>   
>> HP Mobile Data Protection System 3D ACPI driver. Similar to hdaps in functionality.
>> This driver provides 4 kinds of functionality:
>> 1) Creates a misc device /dev/accel that acts similar to /dev/rtc and unblocks
>> the process reading from it when the device detects free-fall interrupt
>> 2) Functions as an input class device to provide similar functionality to
>> hdaps, in order to be able to use the laptop as a joystick
>> 3) Provides an interface similar to hdaps, so that hdapsd could work with it
>> 4) Makes it possible to power the device off.
>>     
>
> I assume this means 'power the sensor down'? What is interface for
> that?
>
> Aha, /sys. Could we simply power off the device when its input device
> is not opened?
>
>   
No, we can't since the sys interface provides the position info and some 
applications (hdaps apps for example) use this interface.
It will be very CPU intensive if I power off the device and power it 
back on every time /sys/ is read - this stuff goes through ACPI
for each read/write.
>> +Description
>> +-----------
>> +
>> +This driver provides support for the HP Mobile Data Protection
>> +System 3D (mdps), which is an accelerometer. HP nc6420, nw9440 and nx9420
>> +are supported right now, but it may work on other models as well. The
>> +accelerometer data is readable via /sys/devices/platform/mdps.
>> +
>> +Sysfs attributes under /sys/devices/platform/mdps/:
>> +position - 2D position that the accelerometer reports. Format: "(x,y)"
>> +position3d - 3D position that the accelerometer reports. Format: "(x,y,z)"
>> +calibrate - read: values (x, y) that are used as the base for input class device operation.
>> +            write: forces the base to be recalibrated.
>> +rate - reports the sampling rate of the accelerometer device in HZ
>> +state - read: the current power state of the accelerometer device
>> +        write: "0" or "1" to power on/off the device
>> +joystick - read: whether the input class device is active or not
>> +           write: "0" or "1" to enable/disable the input device
>> +
>> +Load time parameters:
>> +bool joystick - whether to enable the input class device or not (default 1)
>> +bool power_off - whether to power off the device on module load (default 0)
>> +bool hdaps_compat - Make the driver export same interfaces as hdaps,
>> +	so that apps like hdaps-gl will work the same as with hdaps (default 0)
>> +	The effect of this is:
>> +	1) Instead of /sys/devices/platform/mdps/, /sys/devices/platform/hdaps/ is created
>> +	2) Sensitivity is adjusted to match that of hdaps
>> +bool input_3d - Whether to operate as a 3D input device. (default 0)
>> +		BIG FAT WARNING: Do not enable this mode unless you are sure
>> +		that you want it, since it eats more CPU
>> +
>> +This driver also provides an absolute input class device, allowing
>> +the laptop to act as a pinball machine-esque joystick.
>> +
>>     
>
> 							Pavel
>   

