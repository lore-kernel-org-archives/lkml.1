Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbXGLUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbXGLUG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXGLUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:06:17 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:56474 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXGLUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:06:17 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang\, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	<200707121446.14170.rjw@sisk.pl> <469631FA.2070405@rtr.ca>
	<200707121735.40077.rjw@sisk.pl> <469650DE.4000901@rtr.ca>
	<46965837.8030907@rtr.ca>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 12 Jul 2007 16:05:31 -0400
In-Reply-To: <46965837.8030907@rtr.ca> (Mark Lord's message of "Thu\, 12 Jul
	2007 12\:35\:03 -0400")
Message-ID: <87y7hl2xro.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> writes:

[snip]

> Whoops.. wrong half of the script.
> For TuxOnIce in 10 seconds, it does this:

[snip]

I'd argue that for most usage patterns, it doesn't matter all that much
how long it takes to hibernate and power off the system.  What really
matter is that it is extremely reliable, and how fast it takes to
resume.

The reason for this is as follows:

A typical usage pattern of hibernate on a laptop is to shut the lid,
causing the system to start to hibernate, and to place the machine in
the bag.  This is fine, as long as you aren't too rough moving it into
the bag, and the hibernation is extremely reliable (i.e. there is no
chance that it fails to hibernate, and remains powered on.)  Presumably
some additional userspace logic could help here, like start beeping
loudly if the hibernate fails, or perhaps just initiate a shut down, to
avoid the machine overheating in the bag.

Note that in this usage pattern, it doesn't matter how long it takes to
hibernate, because you don't actually wait for it to finish.  The only
waiting occurs when you turn it on, and the resume path should be
essentially exactly the same under kexec hibernate as with the existing
hibernate.

Thus, if kexec hibernate improves reliability (as it might, given that
it eliminates the need for the freezer), it may be worth the slightly
increased hibernate time.  I think the actual amount of extra time it
will take may be very small; a stripped down kernel may only take a
second or two to initialize.

-- 
Jeremy Maitin-Shepard
