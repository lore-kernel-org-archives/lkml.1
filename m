Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbZJOPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbZJOPy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbZJOPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:54:56 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:41316 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586AbZJOPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:54:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD745B8.3060307@gmail.com>
Date: Thu, 15 Oct 2009 16:54:32 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       Len Brown <lenb@kernel.org>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC] [PATCH 1/2] introduce ALS sysfs class
References: <1253590755.15763.21.camel@rzhang-dt> <4AB8C62F.5020605@cam.ac.uk> <20090923071857.GC8565@elf.ucw.cz>
In-Reply-To: <20090923071857.GC8565@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-09-22 13:42:23, Jonathan Cameron wrote:
>   
>> Zhang Rui wrote:
>>     
>>> Hi, Jonathan,
>>>
>>> this is the refresh ALS sysfs class driver.
>>> I just introduced one sysfs attribute "illuminance", because
>>> I didn't catch the exact meaning of the others like "???infrared".
>>> So it would be great if you can generate an incremental patch
>>> to introduce the other optional attributes needed, and update
>>> the documentation as well. :)
>>>       
>> Will do, though may just leave it out of first pass of drivers
>> (as it may be controversial and it would be nice to get something
>> in place before the arguments begin!)
>>
>> All looks nice and clean. The only real question is whether
>> we want to standardize naming of devices under sysfs (like hwmon does)
>> or allow the individual drivers to do the naming?
>>     
>
> Allow the drivers to do the naming. Having useless name like "als0",
> with als0/name telling me what the driver is is bad.
>   
This topic came up again in the discussion of the tsl2550 driver port.

Jean Delvare raised a point that I'm inclined to agree with (with several
more ports from elsewhere in the kernel underway).

.... (quoted from [PATCH] ALS: TSL2550 driver move from i2c/chips)

> I'd imaging that als-class devices are simply named als%u. Just like
> > > hwmon devices are named hwmon%u, input devices are names input%u and
> > > event%u, etc. I don't know of any class pushing the naming down to its
> > > drivers, do you? The only example I can remember are i2c drivers back
> > > in year 1999, when they were part of lm-sensors.I have personally put
> > > an end to this years ago.
> >
> > This debate started in the als thread. Personally I couldn't care less
> > either way but it does need to be put to bed before that subsystem merges.
> > To my mind either approach is trivially handled in a userspace library
> > so it doesn't matter.  I don't suppose you can remember what the original
> > reasons for squashing this naming approach were?
>
> Code duplication. Having the same unique-id handling code repeated in
> 50 drivers was no fun, as it did not add any value compared to a
> central handling.
>

So does anyone have a strong objection to moving over the more conventional
als0/ naming and move the id handling into the als core?

Note that unless there is a clear reason for doing it any other way it will
probably meet resistance beyond Jean and myself.

Jonathan




