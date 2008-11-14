Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYKNBjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYKNBjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYKNBjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:39:22 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:38701
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYKNBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:39:20 -0500
X-Authority-Analysis: v=1.0 c=1 a=CYKONpC1OwUA:10 a=zn7U-nhvGoYA:10
 a=2iNgh9swn-kA:10 a=kLFhdQYcMTmZJdCFnOcA:9 a=uljgSVZdmygOEJYYVTgA:7
 a=hrHDtWFVZ2iXxlQI2gLL0QmmPY0A:4 a=d4CUUju0HPYA:10 a=LY0hPdMaydYA:10
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <491CCC8A.5090109@euromail.se>
References: <1226585461.6651.52.camel@jg-vaio>
	 <491CCC8A.5090109@euromail.se>
Content-Type: text/plain
Organization: One Laptop Per Child
Date: Thu, 13 Nov 2008 20:39:18 -0500
Message-Id: <1226626758.6651.107.camel@jg-vaio>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 01:55 +0100, Henrik Rydberg wrote:
> > Some systems (e.g. Merl's Diamond Touch), give you an ID associated
> > with the user (in that case, it works by knowing where you are
> > sitting by capacitive coupling). In this case, it is actually where
> > the person is sitting, rather than a particular person.
> 
> This is similar to what I have experienced with the bcm5974. The chip
> outputs some identification based on position, but in the end, the
> information needed is of the kind 'which finger is being lifted', not
> 'where is it lifted'.  Obtaining such tracking information requires
> the additional assumption of continuous movement, which makes the
> usefulness of position-based identifiers somewhat limited. I left out
> some finger details from the spec for that reason.
> 
> > Another case that will be common soon is to be able to sense and
> > identify markers on the surface (which can be distinguished from
> > each other).  I know of at least three hardware systems able to do
> > this. One of these will be in commodity hardware soon enough to
> > worry about immediately.
> 
> Like putting pins on a map and being able to tell where each pin is?

Yes.  And what color each pin is (at least logically, if not literally).
You can distinguish that they are different on some hardware I'm aware
of.

> 
> > So having and ID reported with a touch is clearly needed, whether
> > thumb, index finger, or some marker.
> 
> If a chip can actually classify fingers as index or thumb, it would
> definitely qualify as detailed finger information. Cool.

Certainly there are research systems that do this today (Microsoft's
surface system, to give a concrete example).  They can classify the
fingers on a hand, and tell you the which finger on which hand from the
image the camera sees.

That table can give you proximity as well; so you know the fingers are
roughly how close, even before they touch. (They do this by looking at
how sharp the edges of the fingers are).

Whether there will be commodity hardware able to do this soon is less
clear; but arguably, all it is is a webcam pointing up at the bottom of
the tabletop.

> 
> > Whether such markers would have any user identity directly
> > associated with them is less than clear, though we'll certainly
> > start giving them such identity either by convention or fiat
> > somewhere in the system as the events get processed.  We may also
> > face co-located sensors, where two sensors are geometrically on top
> > of each other (but might even report different coordinates of
> > differing resolutions), but co-aligned.  I'm thinking of the Dell
> > Latitude XT in this case, though I don't yet know enough about it to
> > know if in fact its pen uses a different sensor than the capacitive
> > multi-touch screen.
> 
> This sounds similar to the finger classification, although here
> distinguishing a pen from a finger.

As I said, I don't know if the Latitude hardware is really logically a
single sensor or two, yet, though I hope to know soon.  It can certainly
distinguish your fingers from its stylus.  The stylus clearly also has
proximity information, from playing with it.

The Latitude XT's stylus has a pressure sensor, like a Wacom; I presume
it will be able to have multiple different flavor styluses like Wacom's
do too (e.g. erasers, calligraphic pens, etc...).  Certainly our
software should be able to use many different styluses and distinguish
them, as happens with Wacom tablets today.

The Latitude XT is interesting as it has the first multitouch laptop
screen available, at any price (still not cheap, but some of us can
actually buy them and play with them, which I can't do in the case of a
table display).

> 
> Looking at these three cases, it seems adding something like
> ABS_MT_TOOL_TYPE to the protocol right away makes sense. The wording
> here is chosen with the distinction between (pin1, pin2, index, thumb,
> pen) and (pointing-finger, clicking-finger) in mind.
> 

Yeah, something like this. 

> > Another question is whether an ellipse models a touch adequately at
> > the moment; other sensors may report more complex geometric
> > information.  There is a slippery slope here, of course.  In the
> > extreme case noted above, research systems give you a full image,
> > which seems like overkill.  I also note the current input system
> > does not provide any mechanism or hint to associate an input device
> > with a particular frame buffer or with each other.  Maybe it should,
> > maybe it shouldn't... Opinions?  Hope this helps.  The problem here
> > is to draw a line *before* we win our complexity merit badge, while
> > leaving things open to be extended as more instances of real
> > hardware appears and we have more experience.
> 
> Right. :-) I believe the ellipse model is adequate, because it is the
> simplest model that allows for utilization of the orientation of a
> single finger, for instance to turn a knob. At this point, it seems
> like tough enough a challenge.
> 

Maybe; but modeling this as a parallelogram or trapezoid may be easier
to deal with computationally when you stroke a path from the data, to
which you may have fit a spline....

We learned the hard way about "lumpy lines" in the old X core graphics
about why you don't want circular (or ellipsoidal) pens; you end up with
painfully complex mathematics when stroking a path of such things.  And
the lines were so ugly it made wide lines completely useless.  Cairo
will avoid the lumpy line problem due to anti-aliasing, but the math is
still painful.

The attempt to do Postscript "Red book" described circular pens wastes
like a few hundred K bytes of code in the X server. In short, trying to
solve to the edge of a circle or ellipse is a high order equation. If
you approximate this with a polygon, Hobby showed the resulting lines
are not only much more pleasing when stroked, but are mathematically
much easier to deal with.  And Adobe cheated anyway, it turned out....
We should have fixed the X spec, but never did.  Thankfully, Cairo
finally exists.

So I think something other than an ellipse is probably better....
                           - Jim

-- 
Jim Gettys <jg@laptop.org>
One Laptop Per Child

