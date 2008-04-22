Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYDVJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYDVJ7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYDVJ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:59:32 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59518 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758851AbYDVJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:59:31 -0400
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Frans Pop <elendil@planet.nl>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Guillaume Chazarain <guichaz@yahoo.fr>
In-Reply-To: <20080422085905.GA9939@elte.hu>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <1208854300.4695.7.camel@marge.simson.net>  <20080422085905.GA9939@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 11:59:23 +0200
Message-Id: <1208858363.7115.223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 10:59 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > the 700-800 msecs of delays you see are very "brutal" so there must 
> > > be something fundamentally wrong going on here.
> > 
> > I'm seeing latency hits with 26.git, whereas 25 is hit free.
> 
> ok. I think what happens is that your broken sched-clock hid the real 
> breakage. Lets try fix the real breakage now.
> 
> I've uploaded a new sched-devel.git that is against very latest -git, 
> could you try ftrace (with a sufficiently large 
> /debug/tracing/tracing_max_entries value) - perhaps the 
> worst-case-wakeup-latency tracer shows large latencies? If not, then 
> maybe the sched_switch tracer gives a better insight into what's 
> happening?
> 
> > Erm, should my Q6600 emit such?
> 
> on nohz it could happen - and fixed in -git. Patch looked too dangerous 
> for late-2.6.25 to merge.

Also, it only happens when the cpu has idle time; and that typically
happens when its well,. idle - so not much to schedule wrong.

That said; yes there are boundary effect that could make it show up.

> > On 26.git, I get numbers like yours, but with occasional dips down to 
> > ~700, though the latency hits don't _seem_ to be synchronous with 
> > watch-rq-clock.sh glitchies.
> 
> hm, the dips shouldnt be happening normally.

Agreed, those ought to be gone.. Guillaume do you see any holes in the
current rq clock code?

