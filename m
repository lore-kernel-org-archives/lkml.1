Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZERKeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZERKeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZERKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:33:43 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:40419 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZERKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:33:41 -0400
X-Greylist: delayed 1332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 06:33:40 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A11344B.3000405@cam.ac.uk>
Date: Mon, 18 May 2009 10:11:23 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: felipe.balbi@nokia.com
CC: ext Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kim Kyuwon <q1.kim@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com>
In-Reply-To: <20090518091236.GH4443@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Firstly sorry for lack of response, my email filters hid this in a
folder I don't read often!

I've copied in a few other people I've discussed similar things with
in the past. (sorry if guys if you were getting this via the mailing
list anyway!)

To give you my background, I'm generally interested in sensors
attached to mote's (ultra small linux machines) which tend not to
have user interfaces as such and hence supporting these things for
input is for a matter of interest rather than requirements. 

Whether it makes sense to write unified drivers for my types of uses
and input is still an open question.

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
Enjoy ;)

If you are interested in iio, there's a git tree at
http://www.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

and a draft of a white paper at:

www-sigproc.eng.cam.ac.uk/~jic23/iio.pdf

I'm just waiting to have a spare day to clean that up before posting more widely!
(all comments welcomed!)
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
This was very much one of the thinks IIO was designed to address.
One thing to keep in mind is that the framework
was not intended to replace input / hwmon if they are the appropriate places
for a given driver. In fact one of the conclusions of the discussions linked
above was that, in cases where an accelerometer (or other sensor) serves
different purposes in different devices it may make sense to actually provide
more than one kernel driver. (obviously sharing code where appropriate.

There have been a few off list discussions about how to provide a 'query' type
function so as to allow very different sensors to be used transparently by user
space.  HID was suggested, but to my mind isn't necessarily the way to go. I'm
very much of the view that the kernel should expose enough parameters for userspace
to be able to figure out the 'calibration' type stuff.  This would be in a similar
fashion to that used by hwmon.  I'm not sure I've gotten in right in IIO.

If things are chip specific then it's simply a case of discussing naming / parameter
conventions on the relevant list and keeping definitions in driver. When they start
turning up on lots of chips then they get moved into a 'device type header'
> 
>>>> On Fri, May 15, 2009 at 7:06 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>>>>> Hi Felipe,
>>>>>
>>>>> Adding linux-input and Jonathan, so not deleting any lines from this e-mail.
Thanks.
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
>> bosch-sensortec and KXSD9 from Kionix.
I also have a KXSD9 and there is limited support for it in IIO. It's currently
acting as my example of a minimalist driver (hence I haven't done event handling
or buffering for it yet) - if you want to know how this would work, take a look
at the lis3l02dq accelerometer driver.
> As far as I know, these two
>> accelerometers are quite different from each other and existing
>> accelerometer drivers located /driver/hwmon/ in current Linux kernel.
>> Thus I think sysfs interface (including hwmon-sysfs) is the best
>> solution for setting various parameters of accelerometer..
> 
> what if you wanna use the accelerometer as joystick for gaming ? Imagine
> a portable device...
One option that we agreed to postpone for now in IIO was to use in kernel
interfaces to allow a single underlying layer to ship stuff up to input
if appropriate. It's not something I've looked at a lot, but should be
possible.  As stated above a decision on whether to do this was left 
for a later day in the original lkml discussions.

> 
>> On the other hand, accelerometers are mostly used as Input device in
>> these days.
I wouldn't necessarily say that, though I'll admit that's a big use case.

 Most APIs(input_allocate_device,
>> input_allocate_polled_device, ...) and macros(ABS_X,  ABS_Y, ...)of
>> Input subsystem are useful to accelerometer too. If we create another
>> APIs and Macros for accelerometers, I think It's another duplicate
>> work and result.
beware of the fact that x,y,z aren't exactly cleanly defined for a given
sensor!
> 
> for sure
Agreed.  If you know a given accelerometer is only going to be used for
input then that's where the driver belongs.  However, these chips are
generally capable of a lot more and it tends to be annoying specific.
Take for example things like calibration offsets, and for the really fun
cases on chip event driven ring buffers?  These really don't fit into
your classic input cases.
> 
>> It seems like Dmitry concerns input_dev becomes too big with hundreds
>> of sensors.(right?) However, Market trend makes us consider
>> accelerometer as an input device now. I'm sure there is a good way to
>> add accelerometer input system without enlarging input_dev much.
Optimist ;)
>> In conclusion,
>> We need the inheritance concept in the object-oriented programming.
>> Accelerometer device sometimes can be hwmon device, sometimes input
>> device.
I'd also argue the problem here is that you are going to end up with a
large class of similar devices.  If you start directly adding accelerometers
to Input then the same arguement applies to magnetometers, bend sensors,
gyroscopes etc.  Also beware that many accelerometers are going to be wired
up to adc's (rather than providing digital outputs) so you'll need some
framework to specify this connectivity. (open area in IIO to and the moment).

>So let accelerometer drivers use both APIs of hwmon and input
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
>> 4) Add every new accelerometer into /driver/accelerometer..
 > How about extending these to several kinds of sensors ??
Yup, lots out there - and lots of them don't fit into your nice clean categories.
 Why not having
> a sensor framework that abstracts the creating of the input_dev for
> accelerometer ?
In my view too limited.  (which is where IIO came from in the first place!)
Just because their primary use in your applications is input doesn't mean
that's going to be the case in future.
 But then comes another question: what to do with
> magnetometers, gyroscopes, etc etc ?
The really big and weird and wonderful option is to include general purpose
ADC's.  The really fun bit is that a lot of these devices are made up of
a number of different sensing elements.  So if you have gyro's / accelerometer
/ magnetomers you can have a crack at full orientation / 3d position, but
that's a case of a lot of heavyweight algorithms running in userspace rather
than the kernel.
(oops should have read to end of email before writing earlier bit) 

Other than the focus being a bit more on input that the data capture direction of
the original discussions that led to IIO we are rehashing much the same arguments.

For info, the reason IIO hasn't gone anywhere is that no one who is interested has
had time for reviewing the code. (Last post to lkml got one reply and the poster
in question didn't reply to my response).  If anyone is interested in assisting
with that project then please get in touch!

Jonathan

