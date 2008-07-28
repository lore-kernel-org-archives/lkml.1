Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYG1CCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYG1CCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYG1CCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:02:23 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:60668 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYG1CCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:02:22 -0400
Date: Sun, 27 Jul 2008 18:56:49 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Trent Piepho <tpiepho@freescale.com>,
       Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] leds: make the default trigger name const
In-Reply-To: <20080727231149.1b2508da.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0807271304350.26456@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
 <1217019705-24244-1-git-send-email-tpiepho@freescale.com>
 <20080727020857.GM12191@secretlab.ca> <20080727231149.1b2508da.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Stephen Rothwell wrote:
> On Sat, 26 Jul 2008 20:08:57 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri, Jul 25, 2008 at 02:01:44PM -0700, Trent Piepho wrote:
>>> The default_trigger fields of struct gpio_led and thus struct led_classdev
>>> are pretty much always assigned from a string literal, which means the
>>> string can't be modified.  Which is fine, since there is no reason to
>>> modify the string and in fact it never is.
>>>
>>> But they should be marked const to prevent such code from being added, to
>>> prevent warnings if -Wwrite-strings is used and when assigned from a
>>> constant string other than a string literal (which produces a warning under
>>> current kernel compiler flags), and for general good coding practices.
>>>
>>> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> I would ack this as well, except I am not sure what tree this patch is
> against.  In the current powerpc next tree,

It was against powerpc next from Jul 22nd, current at the time I made the
patch.  It looks like that file has changed in the last few days.  There is a
patch from Anton Vorontsov, "leds:  mark led_classdev.default_trigger as
const", which adds const to one of the structs I modified, but doesn't get the
other one (struct gpio_led).

Then another patch from Nate Case added a new LED chip driver, and the
platform data for this driver was added as "generic led platform data", which
I don't entirely agree with.  And this new struct didn't make default_trigger
const, probably because it was just copied from the gpio led platform data
with some fields removed (so it's not really that generic then, is it?).

I'll send an updated patch for current powerpc next.
