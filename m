Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057Ab0AZLJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab0AZLJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392Ab0AZLJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:09:32 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:39213 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab0AZLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:09:31 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B5ECDBD.8080301@jic23.retrosnub.co.uk>
Date: Tue, 26 Jan 2010 11:10:53 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> <4B573501.9090001@jic23.retrosnub.co.uk> <20100122204718.GA15759@kroah.com> <20100123001414.GB14538@core.coreip.homeip.net> <20100123003112.GA7836@kroah.com> <20100126093422.GA3480@core.coreip.homeip.net> <8A42379416420646B9BFAC9682273B6D0F1DB670@limkexm3.ad.analog.com> <20100126101135.GA3630@core.coreip.homeip.net> <8A42379416420646B9BFAC9682273B6D0F1DB6AE@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0F1DB6AE@limkexm3.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/10 10:25, Hennerich, Michael wrote:
>> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>> On Tue, Jan 26, 2010 at 09:55:45AM +0000, Hennerich, Michael wrote:
>>>
>>>
>>>> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>>>>
>>>> On Fri, Jan 22, 2010 at 04:31:12PM -0800, Greg KH wrote:
>>>>> On Fri, Jan 22, 2010 at 04:14:15PM -0800, Dmitry Torokhov wrote:
>>>>>> On Fri, Jan 22, 2010 at 12:47:18PM -0800, Greg KH wrote:
>>>>>>> On Wed, Jan 20, 2010 at 04:53:21PM +0000, Jonathan Cameron
> wrote:
>>>>>>>> I am not aware of these. Could you direct me to the current
> api? Also note that these
>>>>>>>> aren't the actual alarms, merely a means of enabling the
> relevant event on the related
>>>>>>>> event character device.
>>>>>>>
>>>>>>> Hm, I thought we had an accelerator interface somewhere...
>>>>>>>
>>>>>>
>>>>>> Nope. And I am also interested in this since I am sittign on a
> bunch of
>>>>>> accelerometers, magnetometers, etc drivers that are trying to
> plug into
>>>>>> input sysbsystem and quite unsure what to do with them.
>>>>>>
>>>>>> It was OK whch HDAPS and friends when they were using input for
>>>>>> secondary, toyish purposes, but these new drivers trying to use
> input
>>>>>> devnts as primary API and I am unsure if it is the best
> solution.
>>>>>> Accelerometer might be used as an input device but not always an
> input
>>>>>> device.
>>>>>
>>>>> Yeah, I see it using a joystick interface, which might be
> acceptable for
>>>>> "toy" devices like you say.
>>>>>
>>>>> But for "real" ones, we should do something else.
>>>>>
>>>>> Maybe, for devices that are going to be used by x.org, like the
> "toy"
>>>>> ones, we stick with the current input interface, but for others,
> we use
>>>>> a "real" interface, probably through hwmon, so that users can get
> the
>>>>> real data out in a consistant manner.
>>>>>
>>>>
>>>> I'd rather have all of them use real interface and then have a
> bridge
>>>> to input module to enable toyish mode (unless the device in question
>>>> is really truly an input device).
>>>>
>>>> --
>>>> Dmitry
>>>
>>
>>> I really don't see that hwmon provides facilities like input/evdev
>>> does.  Queuing of events with time stamping and multiple reader
>>> support.
>>
>> I understand that using evdev might be very convenient but I still
>> believe that input should be used for human interfaces, not for generic
>> data acquisition. The idea is that userpsace consumers should be able
> to
>> query device's capabilities and based on those capabilities be able to
>> classify and properly handle the device. Now it all breaks when we get
>> random hardware using EV_ABS/ABS_* for delivering some datastream that
>> has nothing to do with coordinates.
> 
> Acceleration in X,Y,Z translates pretty well in what joysticks deliver.
> 
>>
>>>  The adxl34x accelerometer driver for example is really
>>> intended to be a input device.  Send EV_KEY for x,y,z_TAP detections,
>>> send EV_KEY for 3D orientation sensing, and EV_ABS for acceleration.
>>> With very minor platform data customization you can use this device
>>> for game controls or GUI interaction.  A few examples include digital
>>> picture frames, ebook readers, etc.
>>>
>>
>> I see. However, can it be reasonably used for other purposes?
> 
> Well - it depends. Some applications for Accelerometers also include:
> Personal navigation devices
> Hard disk drive (HDD) protection
> Safety
Just to add the apps I tend see these in (including that particular chip).
Sports performance monitoring (including live feedback and logging situations),
equine gait and I know at least one group who use these cheap 'input' sensors
for UAV navigation and packages instrumenting birds in flight (not sure exactly
which chip they are using right now but I know they were trying to obtain samples
of the adxl345 a while back.)

Obviously not all of the above are under Linux, but given the ease of development
and increasingly good low power and crucially small embedded boards it is
becoming more common.

Round here the smallest end is still bare metal code, but a lot of the initial
prototypes are Linux based.

Jonathan
