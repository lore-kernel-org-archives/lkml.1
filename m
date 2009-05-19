Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZESCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZESCli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 22:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZESClb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 22:41:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10169 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZESCla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 22:41:30 -0400
Date: Tue, 19 May 2009 11:41:24 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
In-reply-to: <20090518091236.GH4443@nokia.com>
To: felipe.balbi@nokia.com
Cc: ext Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>
Message-id: <4A121C54.2040205@samsung.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <20090515131636.GE4443@nokia.com>
 <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com>
 <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
 <20090515200235.GA11829@nokia.com>
 <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com>
 <20090518091236.GH4443@nokia.com>
X-OriginalArrivalTime: 19 May 2009 02:41:24.0619 (UTC)
 FILETIME=[4D2455B0:01C9D82B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe and Jonathan.

Sorry but it's really hard for me to understand Jonathan's email and iio 
driver. [ I'm not the native speaker of English :) ]
Before asking Jonathan a few questions about his comments and iio, I 
want to reply this mail first.

Felipe Balbi wrote:
> On Mon, May 18, 2009 at 09:45:55AM +0200, ext Kim Kyuwon wrote:
>> Hi All,
>>
>> It's very nice of Felipe to make an issue of accelerometers in Linux
>> kernel again.
>> Before further discussions, we'd better see previous threads about
>> accelerometer.
>>
>> http://lkml.org/lkml/2008/5/20/135
>> http://lkml.org/lkml/2008/12/1/156
>> --
>>
>> I have considered how I can add my accelerometer driver into the Linux
>> kernel nicely for a few months.
>>
>> As Trilok said, there are many accelerometer drivers under
>> drivers/hwmon. So I first tried to add my driver as hwmon, but Jean
>> Delvare didn't agree this idea. Please refer to the following URL:
>> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-April/025686.html
>>
>> And from the next URL, Dmitry don't think it is great idea to add
>> accelerometer as Input system.
>> http://lkml.org/lkml/2008/5/27/283
> 
> Good links, I'll read them all :-)
> 
> Thanks
> 
>> On Sat, May 16, 2009 at 5:02 AM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
>>> Hi all,
>>>
>>>
>>> On Fri, May 15, 2009 at 09:30:41PM +0200, ext Mohamed Ikbel Boulabiar wrote:
>>>> I am really interested about that.
>>>>
>>>> But I want to know more about the device, its type, name, ...
>>>> The device isn't HID (Human Interface Device) ? If so, we should
>>>> rethink adding such thing but modify/use hid-input instead.
>>>>
>>>> Because, I have an accelerometer phidget device and it is HID.
>>>> Handling should be the same.
>>> Yeah, let's try to define the best way to expose accelerometers with
>>> linux kernel and avoid a sysfs hell. Better sooner than later.
>> Felipe,
>> Can I ask why did you say "avoid a sysfs hell"?. I have thought Kernel
>> developers prefer sysfs to IOCTL lately.
> 
> For sure sysfs is prefered, but I meant that without a proper
> abstraction or definition of how to export the device, each device
> driver write will export sysfs nodes as they want and that's really bad
> since we create the 'userland interface'. If it's messed up from the
> beginning, it's gonna be like that for ages.

Agreed. Thank you for your explanation.

>>>> On Fri, May 15, 2009 at 7:06 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>>>>> Hi Felipe,
>>>>>
>>>>> Adding linux-input and Jonathan, so not deleting any lines from this e-mail.
>>>>>
>>>>> On Fri, May 15, 2009 at 6:46 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> the following patch is just an idea to see how the community feels about
>>>>>> it. Considering accelerometer devices, you might have different use
>>>>>> cases for it while running different applications. You could be using it
>>>>>> for screen rotation in one case but when opening a game, you could use
>>>>>> it as a game controller by turning the device side-by-side.
>>>>> There was one proposal from Jonathan called Industrial IO patchset
>>>>> which tried to address these sensor devices. Please grep in your
>>>>> linux-kernel archieve. I believe there are accelerometer drivers under
>>>>> drivers/hwmon.
>>> The problem is that it doesn't really seem to me that all accelerometers
>>> will be doing hw monitoring. The ones used in laptops, for sure, trying
>>> to prevent the hd from drying during a fall. But imagine the
>>> accelerometers used in, say, wii-mote, or cellphones, or such stuff ?
>>>
>>> Say we wanna use the accelerometer for both screen rotation and gaming,
>>> that device isn't doing hw monitoring and still we _do_ want to set
>>> different thresholds and irq requests/types for different use cases,
>>> right ?
>> Yes, I agree that accelerometer needs new interface. However setting
>> parameters of accelerometer is very different from devices and device
>> specific. Until now, I met two accelerometer, SMB380 from
>> bosch-sensortec and KXSD9 from Kionix. As far as I know, these two
>> accelerometers are quite different from each other and existing
>> accelerometer drivers located /driver/hwmon/ in current Linux kernel.
>> Thus I think sysfs interface (including hwmon-sysfs) is the best
>> solution for setting various parameters of accelerometer..
> 
> what if you wanna use the accelerometer as joystick for gaming ? Imagine
> a portable device...

So I said that accelerometer driver can use input_register_device, 
input_register_polled_device functions.

>> On the other hand, accelerometers are mostly used as Input device in
>> these days. Most APIs(input_allocate_device,
>> input_allocate_polled_device, ...) and macros(ABS_X,  ABS_Y, ...)of
>> Input subsystem are useful to accelerometer too. If we create another
>> APIs and Macros for accelerometers, I think It's another duplicate
>> work and result.
> 
> for sure
> 
>> It seems like Dmitry concerns input_dev becomes too big with hundreds
>> of sensors.(right?) However, Market trend makes us consider
>> accelerometer as an input device now. I'm sure there is a good way to
>> add accelerometer input system without enlarging input_dev much.
>>
>> In conclusion,
>> We need the inheritance concept in the object-oriented programming.
>> Accelerometer device sometimes can be hwmon device, sometimes input
>> device. So let accelerometer drivers use both APIs of hwmon and input
>> subsystems(hwmon_device_register, input_register_device,
>> input_register_polled_device). Acutally this is what many
>> accelerometer drivers in current Linux kernel are doing, so we don't
>> have to do much.
>>
>> Let's
>> 1) Introduce a new maintainer of accelerometer (Felipe?).
>> 2) Move accelerometer drivers in current Linux kernel to /driver/accelerometer.
>> 3) If we find the common functions of accelerometer or have idea about
>> new API or Macro, let's make at driver/accelerometer/acccelerometer.c,
>> input/linux/acccelerometer.h file or modify input.h little.
>> 4) Add every new accelerometer into /driver/accelerometer.
> 
> How about extending these to several kinds of sensors ?? Why not having
> a sensor framework that abstracts the creating of the input_dev for
> accelerometer ? 

Good point. We should consider the extensibility. I agree a sensor 
framework that abstracts input_dev. However we should discuss with Jean 
Delvare about the boundary between lm-sensors and input(?)-sensors

* However we should first confirm and review that Jonathan's iio can be 
the solution for input(?)-sensors *

 > But then comes another question: what to do with
> magnetometers, gyroscopes, etc etc ??

If we make a extensible sensor driver, I think we can add these new etc 
sensors in the future. step by step.

Regards,
Kyuwon
