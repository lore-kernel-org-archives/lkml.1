Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbXJZQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbXJZQpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765292AbXJZQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:45:09 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:3626 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764354AbXJZQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:45:05 -0400
Date: Fri, 26 Oct 2007 12:44:41 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Ryan Lortie <desrt@desrt.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20071026164441.GI26573@aehallh.com>
Mail-Followup-To: Ryan Lortie <desrt@desrt.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
	linux-input <linux-input@atrey.karlin.mff.cuni.cz>
References: <20070609084800.GR6362@aehallh.com> <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com> <1193191094.32696.2.camel@moonpix.desrt.ca> <200710232333.08306.dmitry.torokhov@gmail.com> <20071024153508.GG26573@aehallh.com> <1193290654.15893.2.camel@moonpix.desrt.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193290654.15893.2.camel@moonpix.desrt.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 01:37:34AM -0400, Ryan Lortie wrote:
> On Wed, 2007-24-10 at 11:35 -0400, Zephaniah E. Hull wrote:
> > We need a way to, at the absolute minimum, unbind the keyboard from the
> > text console.  The current solution sucks for things like rfkill.
> > 
> > I'm not convinced that Ryan's fix is any better, but just saying that X
> > should open the console and ignore the characters is simply not an
> > option as far as I am concerned for X.
> 
> Can you think of any other way to separate things like rfkill/evdev from
> things like the text console that's less hacky than my 'priority'
> scheme?

What we really want to give is exclusitivity verses other 'end users',
as opposed the 'filters'.

I'm defining an 'end user' to be a handler that cares about all the
events from a device and plans on doing something with it.

That would be the console layer for keyboards, /dev/input/mice and
/dev/input/mouse<n> for mice, X for both of those, etc.

A 'filter' cares about a key or two, and might even want to remove it
from the stream, rfkill is a good example.

Now, how do we design for that?  Not a clue right now, still thinking
about it really.

Zephaniah E. Hull.
