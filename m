Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXJWSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXJWSLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:11:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:53843 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbXJWSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b38hKRgM0EdZDQgRW102PJqwRrccoFL3jOqd6jX7ECTG8pSTFjAt3ZrI+l1fA2TEHx8z7f1ZOLvf4ZCQNLXMHkdw7fToByeGo0nmMsZ0Cs3ivHXjOAeFUn3zFz/UtoqUPhY0dhb5x6Nw8vVP8ge2W0f7AeDgWk/OjdHFhU8DCdU=
Message-ID: <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com>
Date: Tue, 23 Oct 2007 14:10:58 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ryan Lortie" <desrt@desrt.ca>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Cc: "Zephaniah E. Hull" <warp@aehallh.com>, linux-kernel@vger.kernel.org,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <1193155059.15426.15.camel@moonpix.desrt.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070609084800.GR6362@aehallh.com>
	 <200706120120.00494.dtor@insightbb.com>
	 <20070612052316.GX6362@aehallh.com>
	 <200706120135.06428.dtor@insightbb.com>
	 <20070612054031.GY6362@aehallh.com> <20070702152044.GA24665@suse.cz>
	 <20070703164555.GA20370@aehallh.com>
	 <1191035147.7025.28.camel@moonpix.desrt.ca>
	 <d120d5000710230621j3913384cn37dbab1a764de31c@mail.gmail.com>
	 <1193155059.15426.15.camel@moonpix.desrt.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Ryan Lortie <desrt@desrt.ca> wrote:
> On Tue, 2007-23-10 at 09:21 -0400, Dmitry Torokhov wrote:
> > Priority/filter idea is different matter. I don't think it is a giood
> > solution. There will always be an "arms race", new applications would
> > like to get in front of the queue all the time and it will be hard to
> > manage. X should just keep console open in raw mode and simply ignore
> > all events coming from it while using evdev driver. I understand that
> > X's hotplug support is getting there so you should be able to switch
> > to pure evdev setup pretty easy.
>
> The only reason that I don't like the numeric priority system is that I
> believe it is arbitrary and a bit kludgy.  I don't think an arms race
> will be a problem.  We don't have a lot of closed source applications
> running as root on Linux and open source projects either choose sane
> values or get patched (by users, distributions, etc) or don't get used.
>
> I do believe there needs to be some concept of filtering events in such
> a way that they reach some clients but not others -- that's half of the
> purpose of this thread.  rfkill wants to be able to see keypresses while
> they are kept away from X.

No, rfkill want to see keypresses, period. It does not care if there
are other applications also seeing the same keypresses, it just does
not want keypresses stolen from it.

Rfkill should work just fine if there is a debug application capturing
events or a OSD utility monitoring RF state. Actually it would be
great if amy of the control utililities were split in 2 parts - one is
daemon running even without X and controlling RF starte, brightness,
suspend, etc, etc, and another part running in X (or some other
environment) providing OSD services. I mean it is really annoying when
you realize you can't suspend witha keypress because you happen to be
a KDM promot and not fully logged into a KDE session...

>  I'd be open to another way of handling this
> but I think any other way will necessarily be more complex to use.
>
> As for X using evdev, it still puts you in a position of two pieces of
> software being required to know what events have been (conceptually)
> "filtered" by various filters running on the system.  ie: the filter
> itself needs to know, and also X needs to know so that it can remove
> those key events from normal delivery.
>

Yes, applications need to decide whether they want to process certain
events or not. But I think that they shodul do it for themselves, not
for other applications. Otherwise dependencies are just insane and you
risk to disturb the peace just by adding another piece in the mix.

-- 
Dmitry
