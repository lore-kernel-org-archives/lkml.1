Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXDTA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXDTA4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXDTA4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:56:35 -0400
Received: from tapsys.com ([72.36.178.242]:34437 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXDTA4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:56:34 -0400
Message-ID: <46280FBE.5080803@madrabbit.org>
Date: Thu, 19 Apr 2007 17:56:30 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
Cc: ray-gmail@madrabbit.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
References: <20070417062621.GL2986@holomorphy.com> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com> <200704200856.06387.kernel@kolivas.org>
In-Reply-To: <200704200856.06387.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> You're welcome and thanks for taking the floor to speak. I would say you have 
> actually agreed with me though. X is not unique, it's just an obvious so 
> let's not design the cpu scheduler around the problem with X. Same goes for 
> every other application. Leaving the choice to hand out differential cpu 
> usage when they seem to need is should be up to the users. The donation idea 
> has been done before in some fashion or other in things like "back-boost" 
> which Linus himself tried in 2.5.X days. It worked lovely till it did the 
> wrong thing and wreaked havoc.

<nod> I know. I came to the party late, or I would have played with it back
then. Perhaps you could correct me, but it seems his back-boost didn't do
any dampening, which means the system could get into nasty capture scenarios,
where two processes bouncing messages back and forth could take over the
scheduler and starve out the rest. It seems pretty obvious in hind-sight
that something without exponential dampening would allow feedback loops.

Regardless, perhaps we are in agreement. I just don't like the idea of having
to guess how much work postgresql is going to be doing on my client processes'
behalf. Worse, I don't necessarily want it to have that -10 priority when
it's going and updating statistics or whatnot, or any other housekeeping
activity that shouldn't make a noticeable impact on the rest of the system.
Worst, I'm leery of the idea that if I get its nice level wrong, that I'm
going to be affecting the overall throughput of the server.

All of which are only hypothetical worries, granted.

Anyway, I'll shut up now. Thanks again for stickin' with it.

Ray
