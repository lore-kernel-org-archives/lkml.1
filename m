Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbXGPA6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbXGPA6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXGPA6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:58:41 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50681
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXGPA6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:58:40 -0400
Date: Sun, 15 Jul 2007 17:51:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <20070716005135.GB8140@srcf.ucam.org>
Message-ID: <Pine.LNX.4.64.0707151747310.25614@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <20070716005135.GB8140@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Matthew Garrett wrote:

> On Sun, Jul 15, 2007 at 02:33:32PM +0200, Rafael J. Wysocki wrote:
>
> (snip)
>
> Many of these assumptions are based on the assumption that we want to
> save a full image of RAM. I'm not convinced that this is true. The two
> things that we need are application state and hardware state.
> Application state can clearly be saved without kernel involvement
> (though restoring some of it may need some help from the kernel...), so
> hardware state is a more interesting question.

one other reason for saving all the ram is that some people want to save 
all the system caches so that the machine is just as responsive immediatly 
after the resume as it was before the hibernate.

> The obvious argument for saving the entirity of memory is that we have
> no mechanism for picking apart hardware state from any other part of the
> kernel. In reality, we're looking at implementing a set of hibernation
> operations anyway - it would be possible to utilise those to save as
> much state as needed. You also get fringe benefits, like being able to
> freeze a process that's accessing a piece of flaky hardware, swap the
> card out (assuming hotplug PCI), restore some amount of state and then
> let the process continue.
>
> I appreciate that this suggestion sounds kind of fragile and
> complicated, but I think that's true of most descriptions of suspend to
> disk :) The main benefit is that it means we can use the hibernation
> infrastructure for other purposes (checkpointing, swapping hardware,
> that kind of thing) and reduce the damage caused by users doing
> seemingly reasonable things (like suspending Linux, booting Windows and
> then writing to a shared partition...).

I see the order being a little different.

if anyone implements a reliable checkpoint/restore of applications then 
that could be used as to pause specific applicaitons, move applications 
from one machine to another, move applications from one kernel to another, 
and as a side effect, as a form of hibernation when you are willing to 
loose your cache in favor of storing as little info as possible (since you 
wouldn't need to store the cache memory or any kernel memory/state)

David Lang
