Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYKMOju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYKMOju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKMOjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:39:40 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:39788
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbYKMOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:39:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=CYKONpC1OwUA:10 a=zn7U-nhvGoYA:10
 a=2iNgh9swn-kA:10 a=08xF6tDYrsdgJydUtqQA:9 a=sCJX3O-BtZDHIudx7iQA:7
 a=XzVQizrypMvrU85mD_-a9gb9-AkA:4 a=d4CUUju0HPYA:10 a=b8hG5vVbyAkA:10
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: rydberg@euromail.se, Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: One Laptop Per Child
Date: Thu, 13 Nov 2008 09:39:23 -0500
Message-Id: <1226587163.6651.65.camel@jg-vaio>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote:

Sorry I'm slightly late to this discussion.

> > is there hardware that can do finger identification? (i.e. thumb 
> > vs. index finger)? 

Yes, in the extreme case.  There are research table systems which image
the surface, and you get an image of the hand above the surface; they
then compute the fingers position relative to the general hand outline,
and which ones/how much of the hand is touching (which are in-focus).
These can also tell you something about proximity (not yet touching the
surface), very much the way magnetic tablet technologies can tell you
proximity. After processing, you get which finger(s) are touching (or
have proximity), associated with a right or left hand, for information.

> Should we accommodate for this?

Should we bother right now? The extreme often becomes the norm with
time, but we need to draw a line at a sane place.  The closely related
case to identifying fingers that I think *is* worth accommodating
immediately I describe below.

> 
> I believe we should start with events that fit the general idea of
> detailed finger information, and which can be produced by at least one
> existing kernel driver, so that we can test it immediately. I believe
> the proposed set pretty much covers it. I would love to be wrong. :-)
> 
> Regarding identification, one of the harder problems involved in
> making use of finger data is that of matching an anonymous finger at a
> certain position to an identified finger, tagged with a number.  This
> is very important in order to know if the fingers moved, which finger
> did the tapping, how much rotation was made, etc. Generally, this is
> the (euclidian) bipartite matching problem, and is one of the major
> computations a multi-touch X driver needs to perform. I can imagine
> such identification features eventually ending up on a chip. Maybe
> someone more knowledgeable in hardware can give us a hint.
> 
> 
> 

I agree with Peter's point that modeling all of this (fingers, markers,
etc) as multiple pointers will cause madness to ensue.

I distinguish devices in my mind is by "sensors".  If there are multiple
touches, markers, fingers, users, all using the same sensor (of
the same resolution), then the information should start off life
together in the same input stream: this way the relative time ordering
of events all makes sense.

Some systems (e.g. Merl's Diamond Touch), also give you an ID 
associated with the user for each touch (in that case, it works
by knowing where you are sitting by capacitive coupling with your
seat). 

Another case that will be common *soon* is to be able to sense and 
identify markers on the surface (which can be distinguished from each
other).  I know of at least three hardware systems able to do this. One
of these will be in commodity hardware soon enough to worry about
immediately.  So having and ID reported with a touch is clearly
needed, whether thumb, index finger, or some marker. 

Whether such markers would have any user identity or other association
with them is less than clear, though we'll certainly start giving them
such identity either by convention or fiat somewhere in the system as
the events get processed.

We may also face co-located sensors, where two sensors
are geometrically on top of each other (but might even report different
coordinates of differing resolutions), but co-aligned.  I'm thinking of
the Dell Latitude XT in this case,  though I don't yet know enough about
it to know if in fact its pen uses a different sensor than the
capacitive multi-touch screen.  I'm still trying to get precise details
on this device.

Another question is whether an ellipse models a touch adequately at the
moment; other sensors may report more complex geometric information.
There is a slippery slope here, of course. In the extreme case noted
above, research systems give you a full image, which seems like
overkill.

I also note the current input system does not provide any mechanism or
hint to associate an input device with a particular frame buffer or with
each other.  Maybe it should, maybe it shouldn't... Opinions?

Hope this helps.  The problem here is to draw a line *before* we win our
complexity merit badge, while leaving things open to be extended as we
have more instances of real hardware and we have more experience.
                        - Jim
-- 
Jim Gettys <jg@laptop.org>
One Laptop Per Child

