Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYJTNdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYJTNdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYJTNcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:32:54 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:60013 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYJTNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:32:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48FC8889.9090600@gmail.com>
Date: Mon, 20 Oct 2008 14:32:57 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <48FB6193.8090803@gmail.com> <48FBBDB7.50305@tremplin-utc.net>
In-Reply-To: <48FBBDB7.50305@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm hopeful it will be rather similar, but time will be judge ;-) I
> believe the main difference in the driver requirement might not so much
> come from the interface, but from the original reason someone put an
> accelerometer in the system. It's in the laptops in order to detect
> free-fall (for harddisk protection). It's in a phone in order to rotate
> the screen when the phone is rotated. It's in the arm of a robot in
> order to provide feedback on the motors. There are guys who just want to
> use it to play neverball on their laptop. A generic accelerometer
> subsystem will have to provide interfaces to comply to all the needs of
> the usages, and should abstract the fact that several interfaces are
> present from the driver.
>   
Agreed to a certain extent. The trick is in avoiding a behemoth of a
driver if people
only want some of the functionality.  Not to mention ensuring partial
drivers supporting
only a subset of the functionality work fine.  For now the target of iio
is brute force
data capture (cause that's what I want most ;) the others will come in time.

The really fun bit is working the optimum message sets to access to the
data you want
as quickly as possible.  All sorts of evil interleaving can be done with
some chips.

>   
>> I'll try and get an updated version of industrialio patches as is out later
>> this week.
>>     
> Great!
>
>   
>>> +Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>>> +position - 3D position that the accelerometer reports. Format: "(x,y,z)"
>>>   
>>>       
>> Hmm. Position? I've probably missed the debate on why it is called
>> this.... 
>>     
> Hehe, probably there has been no debate. I'm using the de-facto standard
> defined by the hdaps driver. You can consider this as another incentive
> to propose an official accelerometer subsystem ;-)
>   
lol. 
>
>   
> Actually, when you leave the laptop without touching it in a calm
> environment, the movement is very little and the detected changes are
> around 1Hz. Anyway, the absolute reason that you cannot use the DRDY
> interrupt is that if you use it, the free-fall and direction detection
> are not usable anymore (interrupt cannot be shared).
>   
Good reason! Though ideally it'll be switchable between the two modes.
(Actually this is pretty common and one of the more annoying things to try
and put a general framework in place for!)


