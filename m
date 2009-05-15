Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZEOUNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZEOUNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZEOUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:13:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:26710 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZEOUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:13:36 -0400
Date: Fri, 15 May 2009 23:02:35 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
Message-ID: <20090515200235.GA11829@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 May 2009 20:13:08.0812 (UTC) FILETIME=[908508C0:01C9D599]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


On Fri, May 15, 2009 at 09:30:41PM +0200, ext Mohamed Ikbel Boulabiar wrote:
> I am really interested about that.
> 
> But I want to know more about the device, its type, name, ...
> The device isn't HID (Human Interface Device) ? If so, we should
> rethink adding such thing but modify/use hid-input instead.
> 
> Because, I have an accelerometer phidget device and it is HID.
> Handling should be the same.

Yeah, let's try to define the best way to expose accelerometers with
linux kernel and avoid a sysfs hell. Better sooner than later.

> On Fri, May 15, 2009 at 7:06 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> > Hi Felipe,
> >
> > Adding linux-input and Jonathan, so not deleting any lines from this e-mail.
> >
> > On Fri, May 15, 2009 at 6:46 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> >> Hi all,
> >>
> >> the following patch is just an idea to see how the community feels about
> >> it. Considering accelerometer devices, you might have different use
> >> cases for it while running different applications. You could be using it
> >> for screen rotation in one case but when opening a game, you could use
> >> it as a game controller by turning the device side-by-side.
> >
> > There was one proposal from Jonathan called Industrial IO patchset
> > which tried to address these sensor devices. Please grep in your
> > linux-kernel archieve. I believe there are accelerometer drivers under
> > drivers/hwmon.

The problem is that it doesn't really seem to me that all accelerometers
will be doing hw monitoring. The ones used in laptops, for sure, trying
to prevent the hd from drying during a fall. But imagine the
accelerometers used in, say, wii-mote, or cellphones, or such stuff ?

Say we wanna use the accelerometer for both screen rotation and gaming,
that device isn't doing hw monitoring and still we _do_ want to set
different thresholds and irq requests/types for different use cases,
right ?

I'll grep around the Industrial IO patchset if that's supposed to a
'sensor fw' sorta thing. Hope it does report the devices as input
devices. I'm pretty sure we're gonna fall into similar issues when
dealing with magnetometers, for instance, what's the best way to expose
those device with current linux frameworks ? It's not really user input
data...

Well, let's see where this discussion takes us. Willing to hear from
Jonatha, Dmitry and all of you guys

-- 
balbi
