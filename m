Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXDTEJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXDTEJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXDTEJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:09:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbXDTEJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:09:58 -0400
Date: Fri, 20 Apr 2007 06:09:33 +0200
From: Nick Piggin <npiggin@suse.de>
To: ray-gmail@madrabbit.org
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070420040933.GA2392@wotan.suse.de>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:26:03PM -0700, Ray Lee wrote:
> On 4/19/07, Con Kolivas <kernel@kolivas.org> wrote:
> >The one fly in the ointment for
> >linux remains X. I am still, to this moment, completely and utterly stunned
> >at why everyone is trying to find increasingly complex unique ways to 
> >manage
> >X when all it needs is more cpu[1].
> [...and hence should be reniced]
> 
> The problem is that X is not unique. There's postgresql, memcached,
> mysql, db2, a little embedded app I wrote... all of these perform work
> on behalf of another process. It's just most *noticeable* with X, as
> pretty much everyone is running that.

But for most of those apps, we don't actually care if they do fairly
degrade in performance as other loads on the system ramp up. However
the user prefers X to be given priority in these situations. Whether
that is the design of X, x clients, or the human condition really
doesn't matter two hoots to the scheduler.


> If we had some way for the scheduler to decide to donate part of a
> client process's time slice to the server it just spoke to (with an
> exponential dampening factor -- take 50% from the client, give 25% to
> the server, toss the rest on the floor), that -- from my naive point
> of view -- would be a step toward fixing the underlying issue. Or I
> might be spouting crap, who knows.

Firstly, lots of clients in your list are remote. X usually isn't.
However for X, a syscall or something to donate time might not be
such a bad idea... but given a couple of X clients and a server
against a parallel make, this is probably just going to make the
clients slow down as well without giving enough priority to the
server.

X isn't special so much because it does work on behalf of others
(as you said, lots of things do that). It is special simply because
we _want_ rendering to have priority of the CPU (if you shifed CPU
intensive rendering to the clients, you'd most likely want to give
them priority to); nice, right?

