Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0BQXIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:08:49 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59101 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0BQXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:08:48 -0500
Date: Wed, 17 Feb 2010 23:08:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] backlight: Add support for exposing backlight types
Message-ID: <20100217230847.GA29144@srcf.ucam.org>
References: <1266442785-3998-1-git-send-email-mjg@redhat.com> <1266442785-3998-2-git-send-email-mjg@redhat.com> <1266447084.6436.483.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266447084.6436.483.camel@rex>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 10:51:24PM +0000, Richard Purdie wrote:
> What I'm interested in is how userspace is going to determine which
> driver(s) it should use?
> 
> BACKLIGHT_GPU > BACKLIGHT_PLATFORM > BACKLIGHT_FIRMWARE ?

Other way around, at least on x86. We generally want to use as abstract 
an approach as possible in order to ensure that we pick respond to 
changes that the firmware has made.

> or something looking at the device names as well along with some kind of
> "XXX is better than YYY"?

In the hypothetical future where we can get plug-in displays with 
backlights yeah.

> > +		The type of interface controlled by <backlight>.
> > +		"firmware": The driver uses a standard firmware interface
> > +		"platform": The driver uses a platform-specific interface
> > +		"gpu": The driver controls hardware registers directly
> 
> These descriptions really don't help me much. I can think of several
> "platform" backlight drivers which control hardware registers directly.
> When people see these described as "gpu", I can see bug reports coming
> in. Would "raw" be a better description?

Sure.

> I'm also wondering how we associate backlights to displays. Lets say I
> have a three output video card which has a backlight control for each
> connected output. "gpu" isn't going to help me much and I suspect the
> framebuffer association code already in the backlight class won't help
> much either since nobody uses it and the framebuffer interfaces are
> mostly replaced with drm on desktops/laptops? Do we have any plans on
> how to handle this - its certainly a related problem.

Right now, control of anything other than internal displays is going to 
involve ddcci which is a whole different set of constraints. The only 
real way of handling that is going to be for userspace to look at the 
parent device of the backlight, I think.

> As an aside for the patch itself, I'd like a note about the list of
> strings in backlight.c needing to be in sync with the ENUM.

Fair enough.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
