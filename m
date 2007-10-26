Return-Path: <linux-kernel-owner+w=401wt.eu-S1761718AbXJZR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718AbXJZR65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXJZR6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:58:50 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:4906 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXJZR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:58:49 -0400
Date: Fri, 26 Oct 2007 13:58:25 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Ryan Lortie <desrt@desrt.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20071026175825.GJ26573@aehallh.com>
Mail-Followup-To: Ryan Lortie <desrt@desrt.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
	linux-input <linux-input@atrey.karlin.mff.cuni.cz>
References: <20070609084800.GR6362@aehallh.com> <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com> <1193191094.32696.2.camel@moonpix.desrt.ca> <200710232333.08306.dmitry.torokhov@gmail.com> <20071024153508.GG26573@aehallh.com> <1193290654.15893.2.camel@moonpix.desrt.ca> <20071026164441.GI26573@aehallh.com> <1193418991.7673.5.camel@moonpix.desrt.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193418991.7673.5.camel@moonpix.desrt.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:16:31PM -0400, Ryan Lortie wrote:
> On Fri, 2007-26-10 at 12:44 -0400, Zephaniah E. Hull wrote:
> > A 'filter' cares about a key or two, and might even want to remove it
> > from the stream, rfkill is a good example.
> 
> The patch introduces two different features that work nicely together
> but, by no means have to be used together.
> 
> 1) set interested events
> 
>   By default, -all- events are delivered to an event device.  you only
>   get selective delivery when you explicitly use the 'set bits' call.
> 
> 
> 2) filter
> 
>   Filter all events that have been delivered to the user from further
>   propagation.
> 
> 
> Notice that if you do not use feature #1 then you get all keystrokes
> delivered to you (unless someone with a higher priority than you did
> some filtering).  If you then use feature #2 then you filter everything
> (since everything is delivered to you).
> 
> 
> 
> I really do think that this is good for your use case.  Your use of it
> would basically involve opening the event device and saying
> "ioctl(turn_filter_on);".  The default case is that all keys are
> delivered (and therefore blocked from anyone below you).


But it's not really above/below, I don't want another X session with the
same priority level coming along and stealing the device, but I do want
to be able to steal it from the console.

I'm just not entirely convinced that we need priority levels, but if we
do go for them, then we want some documentation very clearly spelling
them out.
> 
> 
> 
> Cheers
> 

-- 
