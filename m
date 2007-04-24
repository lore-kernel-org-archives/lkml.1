Return-Path: <linux-kernel-owner+w=401wt.eu-S1031020AbXDXB7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031020AbXDXB7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031023AbXDXB7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:59:16 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:41677
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031020AbXDXB7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:59:15 -0400
Date: Mon, 23 Apr 2007 18:57:37 -0700
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424015737.GA20413@gnuppy.monkey.org>
References: <462D37D2.3060208@goop.org> <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 05:59:06PM -0700, Li, Tong N wrote:
> I don't know if we've discussed this or not. Since both CFS and SD claim
> to be fair, I'd like to hear more opinions on the fairness aspect of
> these designs. In areas such as OS, networking, and real-time, fairness,
> and its more general form, proportional fairness, are well-defined
> terms. In fact, perfect fairness is not feasible since it requires all
> runnable threads to be running simultaneously and scheduled with
> infinitesimally small quanta (like a fluid system). So to evaluate if a

Unfortunately, fairness is rather non-formal in this context and probably
isn't strictly desirable given how hack much of Linux userspace is. Until
there's a method of doing directed yields, like what Will has prescribed
a kind of allotment to thread doing work for another a completely strict
mechanism, it is probably problematic with regards to corner cases.

X for example is largely non-thread safe. Until they can get their xcb
framework in place and addition thread infrastructure to do hand off
properly, it's going to be difficult schedule for it. It's well known to
be problematic.

You announced your scheduler without CCing any of the relevant people here
(and risk being completely ignored in lkml traffic):

	http://lkml.org/lkml/2007/4/20/286

What is your opinion of both CFS and SDL ? How can you work be useful
to either scheduler mentioned or to the Linux kernel on its own ?

> I understand that via experiments we can show a design is reasonably
> fair in the common case, but IMHO, to claim that a design is fair, there
> needs to be some kind of formal analysis on the fairness bound, and this
> bound should be proven to be constant. Even if the bound is not
> constant, at least this analysis can help us better understand and
> predict the degree of fairness that users would experience (e.g., would
> the system be less fair if the number of threads increases? What happens
> if a large number of threads dynamically join and leave the system?).

Will has been thinking about this, but you have to also consider the
practicalities of your approach versus Con's and Ingo's.

I'm all for things like proportional scheduling and the extensions
needed to do it properly. It would be highly relevant to some version
of the -rt patch if not that patch directly.

bill

