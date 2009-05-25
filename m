Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZEYIPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZEYIPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZEYIPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:15:17 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:43198 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZEYIPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:15:11 -0400
Date: Mon, 25 May 2009 17:15:11 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
In-reply-to: <4A16AA1E.9010407@cam.ac.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: felipe.balbi@nokia.com, Kim Kyuwon <chammoru@gmail.com>,
       Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Message-id: <4A1A538F.2030003@samsung.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <20090515131636.GE4443@nokia.com>
 <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com>
 <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
 <20090515200235.GA11829@nokia.com>
 <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com>
 <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk>
 <4A125265.6040509@samsung.com> <4A153E3E.8090509@cam.ac.uk>
 <4A166083.8080704@samsung.com> <4A16AA1E.9010407@cam.ac.uk>
X-OriginalArrivalTime: 25 May 2009 08:15:11.0473 (UTC)
 FILETIME=[EC8E3E10:01C9DD10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> Hi Kyuwon,
>> Jonathan Cameron wrote:
>>> No, the conclusion was to wait and see if this is practical. It was
>>> kept in
>>> mind during the several iterations of design of IIO, but the focus of
>>> development was always high performance capture and handling all the
>>> facilities
>>> of these highly variable sensors as consistently as possible.
>>>
>>> I guess now we are in a position to see if it is indeed practical to
>>> add input
>>> support.
>> Thank you for your clarification.
>>
>>>> I can't understand why you inserted ring buffers related stuffs in iio.
>>>>  Please let me understand in easy words. And please note that in
>>>> /Documentation/SubmittingPatches
>>> Because the hardware I have uses hardware ring buffers e.g. VTI
>>> SCA3000 series,
>>> analog adxl345.  More and more sensors are moving this way as without
>>> a true
>>> real time os, it's the only way of ensuring high data rate data is
>>> available
>>> for sophisticated almost real time processing. 
>> How can you be so sure that more and more sensors use h/w ring buffer?
>> Is there any data or experts who supports your point?
> I'm basing this on observation and believe me I use a lot of different
> sensors and work with people who use a lot more. I'm not going to waste
> my timing getting them to post a series of 'opinions' on this list when
> a bit of Googling and looking at release dates of sensors will give you
> the same information.
> 
> Until recently the only ones I had encountered were VTI's.  Now Analog have
> started producing a range of sensors with various forms of triggered buffer.
> Take a look at their 'new' page.  Admittedly some of the newer ones don't
> fall easily into my current model so some rethinking of elements of it will
> be needed.  The reason none of the below is currently supported is that I
> haven't been able to get them as yet. I'm particularly interested in the
> 16240 for some athlete monitoring applications.
> 
> We have:
> 
> * ADIS16220  (I hadn't even seen this one before) Digital Vibration sensor.
> 	This has a 1024 sample buffer with various possible triggering modes.
> 
> * ADIS16240 Impact sensor and recorder 3x8192 sample buffer using triggered events.
> 
> * ADXL346 Accelerometer. 32 levels of output data FIFO minimizes host processor
> 	load.
> 
> * ADXL335 Analog sensor so unsurprisingly doesn't feature a digital buffer.
> 
> If we hit the more button and select products in the last year we also gain 
> the ADXL345 wich yet again provides a fifo to reduce load on the processor.
> Before that one, I don't think any of Analog's products featured such buffering.
> 
> So we now have only 2 different manufacturers making sensors with ring buffers
> on them. One of which has put them onto 5 out of their last 6 products (though
> I'll admit the 345 and 346 are extremely closely related).  Looks like
> they think there is a market.
> 
>> And although assuming you are right here, STILL only your SCA3000 series
>> have h/w ring buffer. Thus, I think there is no reason the framework
>> should have ring buffer feature
>>
>>> You can't afford to have gaps
>>> in your data.
>>>
>>>  Also, for my primary application (fast, consistent capture
>>> from a number of different sensors) this is the simplest design that
>>> provides
>>> the performance needed.  We spent a lot of time trying to do this in
>>> other
>>> ways.
>> Your words('simplest' and 'spending a lot of time') are subjective.
> Yes, ultimately I wrote a system that fulfilled my requirements, not one
> that was designed to meet yours. Let me reemphasize that the framework
> is very much designed to be modular.  If you don't want ring buffers then
> you don't have to use them.  Their presence has NO effect whatsoever on
> drivers that aren't using them.  In fact, even when the driver does support
> them, I've mostly made it a Kconfig option on a per driver basis.
> 
> For my typical application the more esoteric triggering methods are also
> vital.  If I want to synchronize a linux based mote's capture of an
> accelerometer with a high end motion capture system and not miss a single
> sample, within an adaptable framework then I need pretty much every element
> currently in the IIO system.  Likewise, if I want regular 2Khz sampling of
> an ADC connected via 400Khz i2c then I need that to be supported.  Yes these
> aren't your applications, which I'm assuming from your post are control of
> a pretty user interface, but they are an import class of applications for
> other users within both the academic world and industry.
> 
> 
>>>> 644 4) Don't over-design.
>>>> 645
>>>> 646 Don't try to anticipate nebulous future cases which may or may not
>>>> 647 be useful:  "Make it as simple as you can, and no simpler."
>>> The are useful. I'm using them in real applications every day.  It
>>> might not
>>> be your use case but it is a number of other peoples (some of whom are
>>> cc'd
>>> above).
>> Our objective is merging code upstream. We have lots of kernel drivers
>> and kernel features which we are using everyday However, I know these
>> are can't be merged kernel.
> This is not the place to get into that sort of argument so I'll keep my
> reply to this short.
> 
> Why not?  If you have something that is useful, then why not submit it?

I didn't say we have something useful.

> This is particularly true in cases like this were the useful element
> doesn't change anything already in kernel and hence if people don't want
> it then it won't effect them.

If we submit ugly and messy drivers and kernel features, none would be 
happy.

>>> The absolutely crucial thing about the design is that if you don't
>>> want ring
>>> buffers, then don't use them (by which I mean don't compile them in -
>>> it's a
>>> modular design so if you don't want them you don't have to have them.)
>> I'm just thinking the right functions should be located in the right
>> position. If only SCA3000 series use ring buffer, it should be in the
>> SCA3000 series driver.
> It's not only the SCA3000 series.
> Note whilst they may not matter for your applications the support
> for software ring buffering in kernel is still absolutely vital to me. Also
> see the devices cited above.
>>> In the first instance I probably wouldn't be pushing that element into
>>> the kernel.
>>> As you are illustrating this is controversial and needs a thorough
>>> discussion.
>>>
>>> At that point the whole system reduces to  much simpler core which
>>> handles
>>> the sysfs interface registration and management of chrdevs associated
>>> with events.
>>> At this level it's fairly similar to input, but without the event
>>> aggregation and
>>> with things like event escalation and dynamic chrdev allocation.
>> We already have a nice 'input subsystem'. why not just using 'input
>> subsystem'
> See the original discussion and remember that we are dealing with application
> cases beyond using these devices for human input. To quote Dmitry:
> 
>> I don't think that input subsystem would be the best choice. While we
>> do support the event-driven mechanism for delivering information to
>> userspace input is mostly oriented for human interface devices, not
>> general data acquisition. If anything input_dev is too fat. Another
>> thing is that input layer anonymizes input devices, makes them
>> capability-oriented. I.e. we dont really care what model of joystick
>> we have, we want something that reports ABS_X, ABS_Y, BTN_FIRE and
>> userpsace can use it whether it a simple analog joystick or something
>> fancy and USB connected. For your purposes you probably do want to know
>> what the device is and what exactly being sampled/measured.
> 
>> I'd go with a lean and mean new subsytem.
> (http://lkml.org/lkml/2008/5/21/186)
> 
> Now, you might argue that the resulting subsystem is not lean and mean,
> but to my mind it comes down to a case of what code actually runs on a
> given event.  Large chunks of the core subsystem are concerned with
> simplifying shared functionality between different devices,
> but in most use cases the run path from events happening to them hitting
> userspace is as lean and mean as possible whilst maintaining flexibility
> where needed.
> 
> If you don't care about he anonymous nature of devices under input then
> fine, submit your drivers to their system.  Then if the sensor in question
> becomes useful to someone who does need some of the additional functionality
> that iio provides we will end up with a second driver.  It's exactly this
> case that lead to the conclusion in the original discussion that there may
> be circumstances where a given device has several separate drivers within
> the kernel. Conclusion was that if the requirements were different enough
> and they could not be easily merged, this may be the best way to go.
>>>> I can't understand. Why we should make accelerometer(or sensor)
>>>> framework relate to ADC?
>>> There are a couple of reasons:
>>> 1) Accelerometers are effectively analog sensors wired up to an ADC.
>>> As such
>>> they share a lot of common features.
>>> 2) Many real accelerometer rigs out there actually use a pair of chips,
>>> so as far as Linux is concerned you are talking to an adc not the
>>> accelerometer
>>> on the other side. Handling this case is still an open issue and it
>>> was to this
>>> that I was referring above.
>> If there is still an open issue, it is difficult to merge this IIO
>> subsystem to upstream kernel.
> I disagree. It's irrelevant to merging the subsystem. You don't have to 
> have every use case and every possible setup handled by a subsystem from
> inception.  For now, if you really need your adc connected accelerometer
> to export 'accel_x accel_y' etc then you can trivially write a driver
> for the whole system.  This would obviously lead to a certain amount of
> code duplication and hence I'm suggesting that the question of whether
> this should be a userspace element (similar to lm-sensors config files)
> or the linkages should be specified in kernel (similar to ASoC).
>>>> My two accelerometer are not in this cases. 
>>> Indeed not.  But many others are and here we are talking about a general
>>> framework.
>>>> If really sensors are related to ADC, it's better make this as
>>>> library or
>>>> application.
>>> That is an open question.  There are cases where it would have to be done
>>> in kernel (where both the accelerometer and the adc have separate control
>>> interfaces). 
>> Then you can make another device driver module or API that can help
>> intercommunicate between two devices.
> Yes.  That may be the way to go down the line.
>>>  Why don't we to be simple. Please let me understand in easy
>>>> words.
>>>>
>>>> Let me ask a few question in conclusion.
>>> Firstly thanks for sending this driver, its always enlightening to see
>>> how people have handled such a device.  Out of interest, have you
>>> posted this to the input list?  I'd be interested to see what their
>>> comments are.
>> I can't add this driver to input list, because this kxsd9 driver is for
>> accelerometer.
> Why does this prevent you posting it there?  It is using the input framework
> so if it was going anywhere in the kernel it would require a review and ACK
> from the relevant people on that list in much the same way as it should also
> be posted to the spi / i2c list as appropriate for review. 

OK,

To. Dmitry,
Can I merge my kxsd9 *accelerometer* driver to input system?

>>>> 1) Does your iio subsystem have all functions which attached kxsd9
>>>> driver has? i.e.
>>>> a. works in polling mode
>>> Yes,
>>>> b. works in interrupt mode
>>> No, but only because I was utilizing it as an example of a minimalist
>>> driver.
>>> See the lis3l02dq driver in the git tree for how it would be extended.
>>>
>>> Firstly, beware, the interrupt case for this chip is very different to
>>> the more
>>> common cases where the interrupt in question indicates the
>>> availability of a new
>>> reading.
>>>
>>> As a more general comment, I'd also argue that the reading you
>>> take on interrupt is irrelevant. The event was the threshold pass, not
>>> the
>>> value of the reading. It should be up to userspace to decide if it
>>> cares what
>>> the reading is and if it does, it has a polling mode with which to
>>> read it.
>>> As I read the data sheet, the device isn't storing the accelerations at
>>> interrupt, so the value you are reading is not relevant to the event
>>> at all, but
>>> typically will be another reading.
>>>
>>> I like the code you have for bringing it up from low power mode to
>>> grab a current
>>> value and then go back to sleep. I haven't seen this functionality in
>>> many chips.
>>>
>>> There are a couple of ways that it could be handled.
>>> 1) Register the MOTLat event to be passed up to userspace and let
>>> userspace take
>>>    a reading via the normal poll modes. (pretty much what would happen
>>> in input)
>>>
>>> 2) Configure this as and IIO trigger which would allow it to be used
>>> to 'trigger'
>>>    the reading of a number of other sensors as well as the acceleration.
>>>
>>> It should be possible to support both of these but as per your earlier
>>> comment
>>> about not adding features until they are needed, I'd advocate only
>>> supporting the
>>> first option until the someone needs the second.
>>>
>>>> c. provide an interface to user space in order setting a few parameters
>>>> and read x, y, z variances.
>>> Yes, via sysfs.
>>>  
>>>> 2) How long will it take to your iio subsystem is merged into mainline?
>>> Not sure - I still don't have enough reviewers. As far as I'm
>>> concerned, bar
>>> changes relating to reviews it's been ready for merging for a couple of
>>> months.  Since the last posting that got almost no responses the only
>>> changes
>>> have been minor changes and comment clean ups.
>>> My intention is to shortly seek advice on how to go about doing this, but
>>> my current feeling is that it will have to be done in stages.  The idea
>>> is that each stage will involve a relatively small code base and hence
>>> be easier for reviewers to handle.  The white paper was written to assist
>>> with this process by providing an overview of how everything links
>>> together
>>> without reviewers having to read the full code.
>>>
>>> 1) The core functionality.   This gives us something very close to
>>> input with
>>> the principal changes as described above.
>>>
>>> 2) A set of example drivers
>>>
>>> At this point we will have a common framework against which to merge
>>> new drivers.
>>>
>>> 3) The advanced features (triggering and ring buffering)
>>>
>>> 4) The drivers for devices requiring 3.
>>>  
>>>> I have quick review of you iio subsytem. Sorry but I think it' somewhat
>>>> complicated and have a lot of functions which are still not needed.
>>> By you - I repeat that I have been using this system in anger for about 6
>>> months now.  I only know of one bit of functionality in there that I'm
>>> not
>>> currently using (the first of the trigger lists) and that is simply
>>> because
>>> I haven't completed the driver that uses it as yet and dropping it
>>> would be
>>> a trivial change.
>>>> And
>>>> it seems like your coding style doesn't look like Linux coding style
>>>> that I'm familiar with.
>>> As far as I know the code absolutely conforms to every coding style
>>> convention of the kernel.  The version in the 'mess' branch has a few
>>> comment
>>> clean ups as a result of checking the kernel doc comments.  If you have
>>> specific examples please send them on and I'll be happy to clean them up.
>> For instance, please
>> drivers/industrialio/ -exec ./scripts/checkpatch.pl --file {} \;
> Ok, I'm seeing a couple of minor formatting errors which I typically only
> clean up properly when I am posting a set to lkml.  Those sets are always
> verified with checkpatch. What you are looking at is my development tree
> not one that I've carefully checked before posting.  Some of the errors
> are entirely deliberate.  I frequently use c99 comments in order to
> indicate that I need to clarify them before formally posting patches for
> reviews (precisely because checkpatch ensures I don't forget to do it!)

Your development tree is opened to other developers and other developers 
would evaluate you though the code in your development tree. You can use 
enough c99 comments and other checkpatch errors just in your local repo.

> If that's what you mean by 'your coding style doesn't look like Linux coding
> style' then you are massively exaggerating.

I said "For instance".

> If these sort of things really cause you trouble then look at the formal
> submissions to lkml. If I hadn't wanted to make the latest and most stable
> version of our internal code available as it was relevant to this discussion
> then I would have waited until I had time to clean up trivial formating
> errors.
> 
>>>> I just hope we can add some accelerometer feature into mainline kernel
>>>> as soon as possible ;)
>>> I agree.  The stop gap solution (which a number drivers have taken) is
>>> to put
>>> them in drivers/misc on the basis that when we do have an agreed
>>> system we can
>>> then move them over at a later date.  I have already offered to do the
>>> conversions for a number of such drivers when iio gets merged.
>>>
>>> Jonathan
>>>
>> Finally,
>> Are you OK if someone trys making another framework for input(?)-sensor
>> or accelerometer.
> Of course I have no objections.

Thanks,

> If people want a unified framework useful for all the common applications
> of these devices then it will need to contain equivalents of what IIO does, if
> as previously discussed it makes more sense to have separate drivers then
> go ahead.  I'd advocate posting your current driver to the input list and
> inquiring what their opinions are on the matter.
> 
> My personal opinion on this is:
> 
> 1) The way accelerometers are currently used for input is very simple, much
> more complex systems using information derived from multiple sensors will
> become common in the future (similar to the new wii remotes) or the stuff
> done by companies like Xsens.  This sort of stuff will require some elements
> similar to IIO (principally synchronized triggered capture from multiple
> sensors).
> 
> 2) For the level of device support you are talking about, there is no direct
> reason it shouldn't go into the main input system. There is no need for a new
> subsystem. Over to Dmitry to point out what I'm missing.  For example, the lis3lv02
> driver (in hwmon) does exactly this.  That driver was accepted
> by the input guys. Perhaps a drivers/input/accelerometer directory makes sense
> to group the drivers.

I really respect your enthusiasm.
Thank you
Regards,
