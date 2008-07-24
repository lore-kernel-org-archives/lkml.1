Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYGXMVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYGXMVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYGXMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:20:01 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:40543 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbYGXMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:19:59 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48887377.2030905@cam.ac.uk>
Date: Thu, 24 Jul 2008 13:20:07 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Eric Piel <eric.piel@tremplin-utc.net>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com>	<20080723174801.GC11009@khazad-dum.debian.net>	<48884F04.4070403@tremplin-utc.net> <20080724100833.GB8301@fluff.org.uk>
In-Reply-To: <20080724100833.GB8301@fluff.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ben,
>> In particular, what I think would be worthy would be:
>> * Up to 3 pre-defined axes (X, Y, Z) - that's provided by your current  
>> version of industrialio
>> * If the accelerometer is soldered on the computer, define once for all  
>> to which _physical_ movement corresponds which axis (eg: a laptop on its  
>> normal position going up has axis Z increasing).
>> * Free fall event. Either it's hardware detected, or the accelerometer  
>> infrastructure will detect it in software.
>> * For each axis, what is the maximum and minimum bound and the unit -  
>> Probably worthy for the whole ADC infrastructure
>> * Joystick emulation (calibrated so that when the computer is not  
>> moving, all the values are at 0). All the current drivers have it.
> 
> I think if we're trying to make something that will cover a number
> of device classes, we need to be more like HID and have a system
> that reports and possibly records the following:
Ok, this is the key disagreement at the moment on the approach to be
taken here.  I'd again argue that the purpose of events in this subsys
are very different from what you describing.  Events tend to indicate
that something has happened (eg. the Free fall even mentioned above),
not that the current value of something is x.  It may be that we
will have devices that do indeed act closer to you conventional
user interface device and provide (x moved to 103 etc).  If we
do then this may all need rethinking.
 
> 1) What data is possible to be returned from each event, with the
>    units, magnitude and any scale applied by the device sending.
> 
> 2) Each event should be able to report a number of items, so that
>    if the sensor reports X/Y/Z in one go, there is just a single
>    event containing those values.
Agreed.
 
> 3) A well defined set of information that can be read (like #1)
>    that can provide details of the device and how it relates to
>    the environment it is in.
Indeed, this is crucial and probably forms the next element of the
code to be written.  At the moment I'm inclined to go with an approach
similar to the input subsystem with it's proc interface that provides
a nice machine readable description of device functionality.

Anyone have any other suggestions on how this can be sensibly achieved?

Thanks,
--
Jonathan Cameron
