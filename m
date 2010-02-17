Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0BQWv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:51:58 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60843 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab0BQWv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:51:57 -0500
Subject: Re: [PATCH 2/2] backlight: Add support for exposing backlight types
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1266442785-3998-2-git-send-email-mjg@redhat.com>
References: <1266442785-3998-1-git-send-email-mjg@redhat.com>
	 <1266442785-3998-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 22:51:24 +0000
Message-ID: <1266447084.6436.483.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 16:39 -0500, Matthew Garrett wrote:
> There may be multiple ways of controlling the backlight on a given
> machine. Allow drivers to expose the type of interface they are providing,
> making it possible for userspace to make appropriate policy decisions.

Firstly, I agree we need to solve this problem one way or another. I
want to make that clear. We also need to make sure whatever solution we
pick works for everyone and scales though.

What I'm interested in is how userspace is going to determine which
driver(s) it should use?

BACKLIGHT_GPU > BACKLIGHT_PLATFORM > BACKLIGHT_FIRMWARE ?

or something looking at the device names as well along with some kind of
"XXX is better than YYY"?

We should really have some indication of how these values can be
interpreted in the kernel as documentation.

> +		The type of interface controlled by <backlight>.
> +		"firmware": The driver uses a standard firmware interface
> +		"platform": The driver uses a platform-specific interface
> +		"gpu": The driver controls hardware registers directly

These descriptions really don't help me much. I can think of several
"platform" backlight drivers which control hardware registers directly.
When people see these described as "gpu", I can see bug reports coming
in. Would "raw" be a better description?

I'm also wondering how we associate backlights to displays. Lets say I
have a three output video card which has a backlight control for each
connected output. "gpu" isn't going to help me much and I suspect the
framebuffer association code already in the backlight class won't help
much either since nobody uses it and the framebuffer interfaces are
mostly replaced with drm on desktops/laptops? Do we have any plans on
how to handle this - its certainly a related problem.

As an aside for the patch itself, I'd like a note about the list of
strings in backlight.c needing to be in sync with the ENUM.

Cheers,

Richard

