Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbXJZR3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbXJZR3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXJZR3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:29:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43648 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbXJZR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ko7rRDW370pPQp1qQpPjv+PQw9WPDNETt7Y97ikfzPLMJlGl3K1liyJq3DRFTL2kvodS/dBUL9EpjpxO4ZEHfKE4KjxdrSJdPT/RiME8ZMpJHs9ZR5oAJQj9uDepkS+7xhUY2lCisPNXQX2eAXAZilQkeMIUDsU0psWRPbbBNNk=
Message-ID: <d120d5000710261029t6673c60ci923823fb84cac373@mail.gmail.com>
Date: Fri, 26 Oct 2007 13:29:37 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ryan Lortie" <desrt@desrt.ca>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Vojtech Pavlik" <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
In-Reply-To: <20071026164441.GI26573@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070609084800.GR6362@aehallh.com>
	 <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com>
	 <1193191094.32696.2.camel@moonpix.desrt.ca>
	 <200710232333.08306.dmitry.torokhov@gmail.com>
	 <20071024153508.GG26573@aehallh.com>
	 <1193290654.15893.2.camel@moonpix.desrt.ca>
	 <20071026164441.GI26573@aehallh.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Zephaniah E. Hull <warp@aehallh.com> wrote:
> On Thu, Oct 25, 2007 at 01:37:34AM -0400, Ryan Lortie wrote:
> > On Wed, 2007-24-10 at 11:35 -0400, Zephaniah E. Hull wrote:
> > > We need a way to, at the absolute minimum, unbind the keyboard from the
> > > text console.  The current solution sucks for things like rfkill.
> > >
> > > I'm not convinced that Ryan's fix is any better, but just saying that X
> > > should open the console and ignore the characters is simply not an
> > > option as far as I am concerned for X.
> >
> > Can you think of any other way to separate things like rfkill/evdev from
> > things like the text console that's less hacky than my 'priority'
> > scheme?
>
> What we really want to give is exclusitivity verses other 'end users',
> as opposed the 'filters'.
>
> I'm defining an 'end user' to be a handler that cares about all the
> events from a device and plans on doing something with it.
>
> That would be the console layer for keyboards, /dev/input/mice and
> /dev/input/mouse<n> for mice, X for both of those, etc.
>
> A 'filter' cares about a key or two, and might even want to remove it
> from the stream, rfkill is a good example.
>

No, rfkill does not want to remove anything from the event stream. It
perfectly happy with other users seeing the same events and doing
their own things with them.

> Now, how do we design for that?  Not a clue right now, still thinking
> about it really.
>

I really think that it should be solved by applications themselves.
Applications should only open devices they are interested in and only
process events they are interested in. The rest should be simply
ignored by the application. This is the only sane way. Otherwise we
will need to split applications into first and second class citizens
and have to manage dependencies between them.

The only exception is console because both kerenl and X are fighting
over control of VT switching. As a workaround one could open console
in raw mode. If this feels too "dirty" I guess we could have ioctl for
"taking over console" for applications willing to do so. The ioctl
would disable VT switching and touching LEDs by the console driver.

-- 
Dmitry
