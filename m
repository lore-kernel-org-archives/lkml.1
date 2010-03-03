Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab0CCUIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:08:34 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54380 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0CCUI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BYmVu99XjIRfETl12o9PeCQG//WINlZsIJXHxT6GENkdA9AlJVfEFQL82UV/PPiyKQ
         WjHF3jEdM6lBKPUiUbwge3N0+375C4OgPwOcjxmd8OmdBfco4nZleTZq0t9CwOizQqPo
         absi/Jba7Ti3Jczpsk6Eunjaqzq+cTBda+DrA=
MIME-Version: 1.0
In-Reply-To: <4B8EBC48.8060701@jic23.retrosnub.co.uk>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <4B8EB685.1060302@jic23.retrosnub.co.uk>
	 <1a297b361003031129y6c19ad9cqe8658c2d85d8764@mail.gmail.com>
	 <4B8EBC48.8060701@jic23.retrosnub.co.uk>
Date: Thu, 4 Mar 2010 00:08:21 +0400
Message-ID: <1a297b361003031208s1a4b6f1dm8aa3ac91f6b7ee73@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Manu Abraham <abraham.manu@gmail.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 11:45 PM, Jonathan Cameron
<kernel@jic23.retrosnub.co.uk> wrote:
> Hi Manu,
>
> ...
>> Maybe it make sense to put all Generic sensors into one whole lot,
>> where an application can
>>
>> - read the value from the driver (eg: 0 - 65535)
>>
>> - read from device static information (to identify how the application
>> should treat the values read back.)
>>
>>    - report what type of device it is (Light, Voltage, Acceleration
>> and what not, simple enumeration will help, mayeb you can even have
>> bitwise OR the types, so that you can have a driver with multiple
>> capabilities)
>>    - the max value it can go
>>    - the min value it can go
>>    - the number of steps (gradient) that the driver can do.
>>
>>
>> Maybe such a simplistic interface does help ?
>>
>> The application can simply read the static information from the driver
>> and decide whether it should really handle that driver class.
>
> The more generic sensors are covered by IIO (in staging)
> There is a lot more there as well as an equivalent of what you describe.
>
> The simplest equivalent to this is the hwmon subsystem (from which IIO
> has borrowed a lot of interfaces, as has ALS).
>
> You have a sysfs file per channel, so taking als api as an example:
>
> illuminance0 - Value of illuminance in lux.
>
> If you want your other elements (though no driver provides them at the moment).
>
> illuminance0_max
> illuminance0_min
> illuminance0_values


Just as i thought:

A Class with values to define floor and ceiling and the gradient in
which the driver can provide such an information in a generic way,
rather than limiting to Ambient Light Sensor.

to make it a bit more stylistic, you could provide static information,
such as driver name also alongwith. But in any case, i guess you
wouldn't need more than these

device_name
max_val
min_val
gradient/steps


as static information and a simple value that could be read back.


In (some remote thought) addition, some devices could "possibly" have
levels that you could set the levels at which the device could set of
a trigger, in which case, you might want to write to the driver to set
the value at which you want to trigger of some event. (Don't really
know whether this is applicable, but I have seen it in some
temperature sensors, such a feature)


> For slow devices this is all you need.
> If you are interested in fast devices, take a look at the recently posted IIO ABI spec.
> That uses sysfs files to describe the data that can be read from a character device
> that is fed from a buffer (either hardware or software). It also supports fairly
> advanced event handling (similar to input, but without cross device aggregation)
> and triggering of data capture from various 'interrupt' sources.
>
> It is still somewhat unclear how exactly to marry the high speed data acquisition
> requirements with other 'client' subsystems such as input. All suggestions on that
> are welcome!

I don't know how fast is "fast".

"I think", (based on quick thought) all you might need is a trigger,
whether the userspace application needs to be triggered to read the
value from the driver, or do something exotic.

ie the trigger is a binary only event, as I understand, right ? But in
any case, you define the trigger mechanism in any way, similar to an
interrupt

The data to be read back could be just as generic, in any case, rather
than defining a subsystem per device category..

Regards,
Manu
