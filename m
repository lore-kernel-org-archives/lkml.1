Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXDSW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXDSW5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXDSW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:57:39 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:37164 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbXDSW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:57:37 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ray-gmail@madrabbit.org
Subject: Re: Renice X for cpu schedulers
Date: Fri, 20 Apr 2007 08:56:05 +1000
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
In-Reply-To: <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200856.06387.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 05:26, Ray Lee wrote:
> On 4/19/07, Con Kolivas <kernel@kolivas.org> wrote:
> > The one fly in the ointment for
> > linux remains X. I am still, to this moment, completely and utterly
> > stunned at why everyone is trying to find increasingly complex unique
> > ways to manage X when all it needs is more cpu[1].
>
> [...and hence should be reniced]
>
> The problem is that X is not unique. There's postgresql, memcached,
> mysql, db2, a little embedded app I wrote... all of these perform work
> on behalf of another process. It's just most *noticeable* with X, as
> pretty much everyone is running that.
>
> If we had some way for the scheduler to decide to donate part of a
> client process's time slice to the server it just spoke to (with an
> exponential dampening factor -- take 50% from the client, give 25% to
> the server, toss the rest on the floor), that -- from my naive point
> of view -- would be a step toward fixing the underlying issue. Or I
> might be spouting crap, who knows.
>
> The problem is real, though, and not limited to X.
>
> While I have the floor, thank you, Con, for all your work.

You're welcome and thanks for taking the floor to speak. I would say you have 
actually agreed with me though. X is not unique, it's just an obvious so 
let's not design the cpu scheduler around the problem with X. Same goes for 
every other application. Leaving the choice to hand out differential cpu 
usage when they seem to need is should be up to the users. The donation idea 
has been done before in some fashion or other in things like "back-boost" 
which Linus himself tried in 2.5.X days. It worked lovely till it did the 
wrong thing and wreaked havoc. As is shown repeatedly, the workarounds and 
the tweaks and the bonuses and the decide on who to give advantage to, when 
done by the cpu scheduler, is also what is its undoing as it can't always get 
it right. The consequences of getting it wrong on the other hand are 
disastrous. The cpu scheduler core is a cpu bandwidth and latency 
proportionator and should be nothing more or less.

-- 
-ck
