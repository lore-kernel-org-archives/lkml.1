Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXJXPrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXJXPrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXJXPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:46:56 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:4841 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXJXPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:46:56 -0400
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 11:46:55 EDT
Date: Wed, 24 Oct 2007 11:35:08 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ryan Lortie <desrt@desrt.ca>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20071024153508.GG26573@aehallh.com>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Ryan Lortie <desrt@desrt.ca>, linux-kernel@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	linux-input <linux-input@atrey.karlin.mff.cuni.cz>
References: <20070609084800.GR6362@aehallh.com> <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com> <1193191094.32696.2.camel@moonpix.desrt.ca> <200710232333.08306.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710232333.08306.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 11:33:08PM -0400, Dmitry Torokhov wrote:
> On Tuesday 23 October 2007, Ryan Lortie wrote:
> > On Tue, 2007-23-10 at 14:10 -0400, Dmitry Torokhov wrote:
> > > No, rfkill want to see keypresses, period. It does not care if there
> > > are other applications also seeing the same keypresses, it just does
> > > not want keypresses stolen from it.
> > 
> > Right.  This is exactly the problem.  The current grab API exists to
> > prevent keys from being delivered to normal users, but rfkill still
> > wants to see them.
> > 
> > No matter how you slice it, if both of these desires are to be satisfied
> > then there needs to be some sort of a system to differentiate between
> > rfkill and "normal users".  That's what the priority is here.
> > 
> 
> And the solution is pretty simple - do not use grab.

xf86-input-evdev will never open the console in raw mode and toss the
data, it's not going to happen.

We need a way to, at the absolute minimum, unbind the keyboard from the
text console.  The current solution sucks for things like rfkill.

I'm not convinced that Ryan's fix is any better, but just saying that X
should open the console and ignore the characters is simply not an
option as far as I am concerned for X.

Zephaniah E. Hull.
> 
> -- 
> Dmitry
> 

-- 
