Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYGXKIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYGXKIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYGXKIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:08:46 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:63987 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbYGXKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:08:45 -0400
Date: Thu, 24 Jul 2008 11:08:33 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
Message-ID: <20080724100833.GB8301@fluff.org.uk>
References: <488763AD.4050400@gmail.com> <20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48884F04.4070403@tremplin-utc.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:44:36AM +0200, Eric Piel wrote:
> Henrique de Moraes Holschuh schreef:
>> On Wed, 23 Jul 2008, Jonathan Cameron wrote:
>>> The subsystem is now in a functional state with a small set of drivers:
>>>
>>> Max1363 (supports numerous Maxim i2c ADC's) (tested with max1363 and max1238 chips)
>>>    - Uses a periodic timer to provide ring buffer mode.
>>>    - All reads form these devices are scan modes so direct single element access
>>>      is not provided.
>>>    - Monitor mode on max1363 is not yet supported (need to do a bit debugging of
>>>      the board I have so as to be able to test this).
>>>
>>> ST LIS3L02DQ - SPI accelerometer.
>>>    - Uses a datardy interrupt to driver a software ring buffer.
>>>    - Most functionality of this device is supported.
>>>
>>> VTI SCA3000 (tested with an e05)
>>>    - Hardware ring buffer.
>>
>> I'd like to see something done to have the common parts of interfaces of the
>> same class (e.g. accelerometers) be standard.  Like hwmon does with
>> temp#_input, etc.
>>
>> Otherwise you made it easier to write drivers, but did nothing to help
>> userspace to USE the drivers :-)
> Hi,
> I completely agree with Henrique. There already exist 3 accelerometer  
> drivers in the kernel (and I'm writing a fourth on). What we are  
> desperately in need of is a _user_ interface. So that a generic program  
> can pop up and say "Oh, there is an accelerometer on this computer, I'll  
> use it to detect free falls."
>
> IMHO, I think the ADC should have a much more specific and specialised  
> (user and kernel) API corresponding to the accelerometers. Granted, you  
> probably had in mind only the accelerometers for industrial usage, but  
> it would be much better if the current accelerometer drivers had a  
> reason to be ported to this new subsystem.
>
> In particular, what I think would be worthy would be:
> * Up to 3 pre-defined axes (X, Y, Z) - that's provided by your current  
> version of industrialio
> * If the accelerometer is soldered on the computer, define once for all  
> to which _physical_ movement corresponds which axis (eg: a laptop on its  
> normal position going up has axis Z increasing).
> * Free fall event. Either it's hardware detected, or the accelerometer  
> infrastructure will detect it in software.
> * For each axis, what is the maximum and minimum bound and the unit -  
> Probably worthy for the whole ADC infrastructure
> * Joystick emulation (calibrated so that when the computer is not  
> moving, all the values are at 0). All the current drivers have it.

I think if we're trying to make something that will cover a number
of device classes, we need to be more like HID and have a system
that reports and possibly records the following:

1) What data is possible to be returned from each event, with the
   units, magnitude and any scale applied by the device sending.

2) Each event should be able to report a number of items, so that
   if the sensor reports X/Y/Z in one go, there is just a single
   event containing those values.

3) A well defined set of information that can be read (like #1)
   that can provide details of the device and how it relates to
   the environment it is in.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
