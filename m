Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXFLFUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXFLFUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXFLFUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:20:04 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:19662 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXFLFUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:20:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYmAH7JbUZKhRO4UGdsb2JhbACHM4gMAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Date: Tue, 12 Jun 2007 01:19:59 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com> <200706120107.13655.dtor@insightbb.com> <20070612051210.GW6362@aehallh.com>
In-Reply-To: <20070612051210.GW6362@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706120120.00494.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 01:12, Zephaniah E. Hull wrote:
> On Tue, Jun 12, 2007 at 01:07:13AM -0400, Dmitry Torokhov wrote:
> > Hi Zephaniah,
> > 
> > On Saturday 09 June 2007 04:48, Zephaniah E. Hull wrote:
> > > EVIOCGRAB is nice and very useful, however over time I've gotten
> > > multiple requests to make it possible for applications to get events
> > > straight from the event device while xf86-input-evdev is getting events
> > > from the same device.
> > > 
> > > Here is the least invasive patch I could think of, it changes the
> > > behavior of EVIOCGRAB in some cases, specificly behavior is identical if
> > > the argument is 0 or 1, however if the argument is true and != 1, then
> > > it does a 'non exclusive grab', a better name might be handy.
> > > 
> > > What this does is allow the events to go to everything that's using
> > > evdev to get events, but grabs it from anything else.  About as close to
> > > what people want as I can get, and fairly non-invasive.
> > 
> > Unfortunately this also robs non-legacy input handlers (such as
> > rfkill-input) of input events. Does xf86-input-evdev really needs to
> > grab devices exclusively? I guess we can't abandon the standard
> > keyboard driver until X supports hotplugging. How close is it to
> > support devices coming and going?
> 
> Er, to explain.
> 
> The current EVIOCGRAB does an exclusive grab that prohibits rfkill-input
> and friends from working.
> 

I understand that.

> As it is the only way to disable the legacy input handlers,
> xf86-input-evdev has been using it since we added it.
>

Like I said I would love if xf86-input-evdev did not grab the
device at all.
 
> The patch is to let us cause only things that use /dev/input/event<n> to
> get events, thus, a non-exclusive grab.
> 
> This basicly disables the legacy input handlers, and it's the least
> invasive patch I could think of.
> 

But rfkill-input is not a legacy handler. My objection is that with your
solution you still will rob handlers such rfkill-input of events.

> Going for a separate ioctl would also work, but in some ways it would
> make supporting it more of a pain.
> 
> I don't care _that_ much either way, as long as we can get a way to
> disable the legacy events while allowing other things to get the events
> too.
> 
> Zephaniah E. Hull.
> >  
> > If we can't remain as is until X hotplug is ready then I'd rather had
> > a separate ioctl that disables legacy input handlers (keyboard, mousedev)
> > for a given input device.
> > 
> > -- 
> > Dmitry
> > 
> 

-- 
Dmitry
