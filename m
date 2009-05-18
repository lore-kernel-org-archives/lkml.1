Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZERKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZERKnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZERKnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:43:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33812 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZERKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:43:36 -0400
Date: Mon, 18 May 2009 13:31:30 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jonathan Cameron <jic23@cam.ac.uk>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       ext Kim Kyuwon <chammoru@gmail.com>,
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
Message-ID: <20090518103130.GK4443@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A11344B.3000405@cam.ac.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 May 2009 10:42:56.0225 (UTC) FILETIME=[6777CD10:01C9D7A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 18, 2009 at 12:11:23PM +0200, ext Jonathan Cameron wrote:
> Hi All,
> 
> Firstly sorry for lack of response, my email filters hid this in a
> folder I don't read often!
> 
> I've copied in a few other people I've discussed similar things with
> in the past. (sorry if guys if you were getting this via the mailing
> list anyway!)
> 
> To give you my background, I'm generally interested in sensors
> attached to mote's (ultra small linux machines) which tend not to
> have user interfaces as such and hence supporting these things for
> input is for a matter of interest rather than requirements. 

You're right here...

> Whether it makes sense to write unified drivers for my types of uses
> and input is still an open question.

I guess iio could provide 'links' to other subsystems where applicable.

> If you are interested in iio, there's a git tree at
> http://www.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

cloning :-p

> and a draft of a white paper at:
> 
> www-sigproc.eng.cam.ac.uk/~jic23/iio.pdf

Printed

> This was very much one of the thinks IIO was designed to address.
> One thing to keep in mind is that the framework
> was not intended to replace input / hwmon if they are the appropriate places
> for a given driver. In fact one of the conclusions of the discussions linked
> above was that, in cases where an accelerometer (or other sensor) serves
> different purposes in different devices it may make sense to actually provide
> more than one kernel driver. (obviously sharing code where appropriate.

why not one kernel driver exporting the device through different
subsystems ?? Otherwise we'd need to fake it's a multifunction device,
right ?!?

> There have been a few off list discussions about how to provide a 'query' type
> function so as to allow very different sensors to be used transparently by user
> space.  HID was suggested, but to my mind isn't necessarily the way to go. I'm
> very much of the view that the kernel should expose enough parameters for userspace
> to be able to figure out the 'calibration' type stuff.  This would be in a similar
> fashion to that used by hwmon.  I'm not sure I've gotten in right in IIO.
> 
> If things are chip specific then it's simply a case of discussing naming / parameter
> conventions on the relevant list and keeping definitions in driver. When they start
> turning up on lots of chips then they get moved into a 'device type header'

right

> Agreed.  If you know a given accelerometer is only going to be used for
> input then that's where the driver belongs.  However, these chips are
> generally capable of a lot more and it tends to be annoying specific.
> Take for example things like calibration offsets, and for the really fun
> cases on chip event driven ring buffers?  These really don't fit into
> your classic input cases.

but that'll never be the case. It can be used as input only in my device
but what about yours ? That's why we need ways to make the driver as
generic as possible so it can be used for several applications.

> I'd also argue the problem here is that you are going to end up with a
> large class of similar devices.  If you start directly adding accelerometers
> to Input then the same arguement applies to magnetometers, bend sensors,
> gyroscopes etc.  Also beware that many accelerometers are going to be wired
> up to adc's (rather than providing digital outputs) so you'll need some
> framework to specify this connectivity. (open area in IIO to and the moment).

sure, I agree with you here.

> >So let accelerometer drivers use both APIs of hwmon and input
> >> subsystems(hwmon_device_register, input_register_device,
> >> input_register_polled_device). Acutally this is what many
> >> accelerometer drivers in current Linux kernel are doing, so we don't
> >> have to do much.
> >>
> >> Let's
> >> 1) Introduce a new maintainer of accelerometer (Felipe?).
> >> 2) Move accelerometer drivers in current Linux kernel to /driver/accelerometer.
> >> 3) If we find the common functions of accelerometer or have idea about
> >> new API or Macro, let's make at driver/accelerometer/acccelerometer.c,
> >> input/linux/acccelerometer.h file or modify input.h little.
> >> 4) Add every new accelerometer into /driver/accelerometer..
>  > How about extending these to several kinds of sensors ??
> Yup, lots out there - and lots of them don't fit into your nice clean categories.
>  Why not having
> > a sensor framework that abstracts the creating of the input_dev for
> > accelerometer ?
> In my view too limited.  (which is where IIO came from in the first place!)
> Just because their primary use in your applications is input doesn't mean
> that's going to be the case in future.

well, I'm thinking mostly about accelerometers, mostly. But same comment
applies to magnetometers, those can't be exported through input, that
one doesn't make sense at all, so how to export it ? and when that's
defined, make iio export helper functions for registering such devices..

-- 
balbi
