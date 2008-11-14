Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYKNAzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYKNAzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYKNAzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:55:43 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:51985 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYKNAzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:55:41 -0500
Message-ID: <491CCC8A.5090109@euromail.se>
Date: Fri, 14 Nov 2008 01:55:38 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: jg@laptop.org
CC: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
References: <1226585461.6651.52.camel@jg-vaio>
In-Reply-To: <1226585461.6651.52.camel@jg-vaio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L0myI-0004SA-6D.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1L0myI-0004SA-6D 73713c3c62759198c4b7c26e8e40bfba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some systems (e.g. Merl's Diamond Touch), give you an ID associated
> with the user (in that case, it works by knowing where you are
> sitting by capacitive coupling). In this case, it is actually where
> the person is sitting, rather than a particular person.

This is similar to what I have experienced with the bcm5974. The chip
outputs some identification based on position, but in the end, the
information needed is of the kind 'which finger is being lifted', not
'where is it lifted'.  Obtaining such tracking information requires
the additional assumption of continuous movement, which makes the
usefulness of position-based identifiers somewhat limited. I left out
some finger details from the spec for that reason.

> Another case that will be common soon is to be able to sense and
> identify markers on the surface (which can be distinguished from
> each other).  I know of at least three hardware systems able to do
> this. One of these will be in commodity hardware soon enough to
> worry about immediately.

Like putting pins on a map and being able to tell where each pin is?

> So having and ID reported with a touch is clearly needed, whether
> thumb, index finger, or some marker.

If a chip can actually classify fingers as index or thumb, it would
definitely qualify as detailed finger information. Cool.

> Whether such markers would have any user identity directly
> associated with them is less than clear, though we'll certainly
> start giving them such identity either by convention or fiat
> somewhere in the system as the events get processed.  We may also
> face co-located sensors, where two sensors are geometrically on top
> of each other (but might even report different coordinates of
> differing resolutions), but co-aligned.  I'm thinking of the Dell
> Latitude XT in this case, though I don't yet know enough about it to
> know if in fact its pen uses a different sensor than the capacitive
> multi-touch screen.

This sounds similar to the finger classification, although here
distinguishing a pen from a finger.

Looking at these three cases, it seems adding something like
ABS_MT_TOOL_TYPE to the protocol right away makes sense. The wording
here is chosen with the distinction between (pin1, pin2, index, thumb,
pen) and (pointing-finger, clicking-finger) in mind.

> Another question is whether an ellipse models a touch adequately at
> the moment; other sensors may report more complex geometric
> information.  There is a slippery slope here, of course.  In the
> extreme case noted above, research systems give you a full image,
> which seems like overkill.  I also note the current input system
> does not provide any mechanism or hint to associate an input device
> with a particular frame buffer or with each other.  Maybe it should,
> maybe it shouldn't... Opinions?  Hope this helps.  The problem here
> is to draw a line *before* we win our complexity merit badge, while
> leaving things open to be extended as more instances of real
> hardware appears and we have more experience.

Right. :-) I believe the ellipse model is adequate, because it is the
simplest model that allows for utilization of the orientation of a
single finger, for instance to turn a knob. At this point, it seems
like tough enough a challenge.

