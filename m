Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXIRI4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXIRI4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbXIRIzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:55:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:21539 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXIRIzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KFa9+PNDfOgCkmlMVT2JNhdhXFY20Jg9g56n4LZ4HVARpWXZS3IYqmWQdnjink8x8AlgKVAh6Xif0P/F7KF8ksu910JWjyKNGs+gThgJRScsgirfa96PZMhRz3mxGQKFC3RIrPn27QzFIoBtWOBMglYBFcsoHkRRXbuo9VoZakI=
Message-ID: <d9def9db0709180155l69991efcr37e9006e282270fc@mail.gmail.com>
Date: Tue, 18 Sep 2007 10:55:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle Foks" <jelle@foks.8m.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Alan Cox" <alan@redhat.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <46EF8A1F.7040309@foks.8m.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <20070914135237.GB19311@devserv.devel.redhat.com>
	 <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com>
	 <46EF8A1F.7040309@foks.8m.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Jelle Foks <jelle@foks.8m.com> wrote:
> Markus Rechberger wrote:
> > On 9/14/07, Alan Cox <alan@redhat.com> wrote:
> >> On Fri, Sep 14, 2007 at 01:17:05AM +0200, Markus Rechberger wrote:
> >>> what stops vendors of using the current existing code to achieve that
> >>> goal. They could provide binary drivers with the existing API.
> >> If you feel lucky about the GPL
> >>
> >>> What stops companies to intercept the ioctl calls and overriding some
> >>> I2C commands?
> >> The GPL - derivative work is the boundary not code linkage. Possibly a
> >> userspace
> >> tuner hack would probably fit this too. Especially if a specific vendor
> is
> >> producing both bits together and trying to claim they are independant.
> >>
> >>> How about proprietary video formats, would you also place the decoding
> >>> algorithms in kernel  just to force companies to release their code
> >>> for it?
> >> No, I would assume they'd provide a proprietary conversion library that
> >> no nobody would use (just like their hw). We keep format conversion
> firmly
> >> seperated from hardware I/O processing.
> >>
> >
> > In general there are known formats available, the drawback is that every
> TV
> > application deals with it in a non-unified way at the moment, meaning alot
> > code duplication in userspace since there's no library available at the
> moment
> > which does the videoconversion from one to another format. Such a library
> is
> > beeing developed at the moment which gets plugged infront of accessing
> > the devicenodes.
>
> IMHO...
>
> The reason why there is no single 'format conversion library' that
> everybody uses is because of the large differences between requirements
> for such a thing. The line between 'format conversion' and things such
> as a video codec, or image processing is very vague. For example: Some
> apps just want compressed video format output. Would video compression
> be part of such a 'format conversion library'? If so, then which
> compressed video formats? Proprietary ones too? If not all formats that
> exist are supported, it would not be complete for some or many apps, and
> maybe not even useful at all (because integrating any necessary
> pixel-format conversion into the compression routines may be more
> efficient than making multiple passes over the data with separate
> libraries). Will the library include resizing? If so, which resampling
> algorithms? Then how about rotation? Then maybe geometrical mapping
> (games could want that)? Will the library be able to adjust
> brightness/contrast/saturation in software? If so, then what about noise
> filtering (which algorithms?), etc... perhaps the library should go all
> the way, bind to port 80 and serve-up a live video stream
> 'youtube-style'? ok, now that would definitely go too far...
>
> The question is: Where exactly to put the boundary?
>

good statement, the absolute goal should be that enduser applications can
handle videostreams as easy as possible. This is currently not given.
For example I have devices which work with ekiga, and some devices
which don't work with ekiga.
Why so? Ekiga already uses a rather big library for handling videodevices.
Another point is why doesn't tvtime support digital audio?
People have to run sox in the background to get any sound piped from
the corresponding dsp node to the soundcard, and also this is no general
way. So first people have to look up what the correct audio node of their
TV device is... (there are small scripts available which lets the users select)
But I also think this should happen automatically.
There are many devices out there which don't even include all ioctl calls
which are documented in the specs.
And since sometimes the API needs to be updated a library could handle this
in a better way.
I see the whole v4l-dvb project as half way done at the moment because of
the unflexibility of the whole system.

> My point is that format conversion is not a video capture driver issue.
> Sure, it is convenient for apps to be able to use standard libraries
> that perform certain functions with optimized code, etc, but for the
> purpose of capturing video (media) it's not always necessary to convert
> the output into something different before the data is useful for an app.
>

this is just a thought, I think a pluggable mechanism would be nice for that.
The library could query the device about it's capabilities and if it returns a
non standard videoformat just add a mechanism for loading the corresponding
videocodec if available.

> Certain format conversions can be done very efficiently inside video
> cards, for example, and an app may prefer to use that. If a video card
> has such functionality, access to it should be part of its driver.
>

yes, this would always be the optimal way

> Applications needing format conversions would benefit tremendously from
> a good, powerful, flexible, efficient, etc, library that removes the
> necessity for each application to choose between using a video-card
> accelerator, or MMX code, or SSE code, or another method to do the work.
> Maybe it should allow applications to request a 'media stream' in a
> given format and container, with conversion automagically happening when
> needed, as efficiently as possible (or at the requested quality level).
>

yes I also agree with that.

> But that doesn't mean that that library should be an integrated part of
> the video capture interface. The boundary of the 'media capture
> interface' driver should be on the data, as delivered by the video
> capture interface.
>

I would prefer to abstract the ioctl calls from the media applications
if possible.
Sometimes API changes are unavoidable and even make sense instead of
carrying around old crufted mechanisms, and since there's currently not a
single TV application out there which supports all available devices it would
make more sense to work on a better infrastructure for all that.

> The reason is that the 'best' way to do format conversions depend on the
> application requirements (what formats can the app use directly?), on
> the available hardware (is there an accelerator that can help?), and on
> the quality expectation or system issues (is the CPU the bottleneck or
> is the USB bus saturated? Do we request JPEG from the webcam and
> decompress into YUV, or do we request the RAW bayer from the
> high-quality image sensor and convert that into YUV?). Choices, choises...
>

yes there are many ways. I like the idea of such a library because it could
even allow to integrate complete userspace drivers in certain cases.
I posted a link within that thread that there's a driver which intercepts all
ioctl calls and which is completly done in userspace. By using a library
the LD_PRELOAD hack wouldn't even be needed and that device could be
integrated flawlessly into a video infrastructure.
I know that such a userspace driver would be slower than the inkernel driver
although I think it's up to the developer what he wants to do.

> That means that IMHO, to prevent having runaway complexity plus chasing
> a moving target, format conversion should definitely not be embedded in
> the API to access video capture hardware, unless the hardware itself
> offers format conversion functions (for example, as it does now, by
> allowing choice of the output format, but only for formats that the
> hardware itself supports directly).
>
> > Although in the long run I'm looking forward to reuse the userspace tuners
> with
> > such a library infront of everything by using i2c-dev.
> > This would also make it easy to reuse the sample code of several
> companies,
> > without having to cut out several features of the drivers and to rewrite
> them
> > to an inkernel format.
>
> It may make things 'easy' if it makes it easy to use existing (?) code
> from other sources, but that's not a reason why such an interface is
> technically superior. For example, 'ndiswrapper' makes it very easy to
> use certain wireless card drivers, but that doesn't mean (by far) that
> ndiswrapper's method results in the best wireless card drivers for Linux.
>
> It sounds to me that your approach is more similar to ndiswrapper, for
> practical reasons 'this is how I can make it work with less effort' than
> it is similar to a full-blown Linux driver 'this is the best way to make
> a reliable and efficient driver for this kind of hardware'. Linux
> _users_ may need to use ndiswrapper right now, but Linux itself needs
> real drivers, not a compromise.
>

ndiswrapper is quite different, I still nativly compile the code on Linux and
even the sources are available.
I just tried to integrate a newer kind of module, as for me I don't want to
rewrite the algorithms of drivers which I'm able to reuse in userspace,
the example which I have here right now even uses C++ in userspace
and all I do is to use the API of these sample sources and package everything
into such a userspace library which can directly be used by the driver.
It's not my job to reinvent the work of companies (and I'm not even
interested in that) if they agree with delivering code which can be easily
integrated, as for me it's reaching the goal by the shortest path first
approach.

Although there are 2 projects going on at the moment, my one is capable
of pushing some drivers to userspace, the other one is still in progress and
I don't know when it will be finished (since I don't even work on that)
During that time the driver will internally depend on the kernel to userspace
bridge; As soon as the userspace drivers can be plugged to the media library
infront of the devicenodes I intend to remove the kernel-userspace stub..
but this might take a while if not several months.

Markus
