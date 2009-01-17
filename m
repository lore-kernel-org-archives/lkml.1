Return-Path: <linux-kernel-owner+w=401wt.eu-S1765001AbZAQQ3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765001AbZAQQ3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762910AbZAQQ2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:28:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:47572 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754981AbZAQQ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:28:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+0gJQQ1AS0XOy0XzkZApsMf8IRily3lUmGgGACbr
	CsLz/tn71NIrLP
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090117161222.GC31601@elte.hu>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <20090117161222.GC31601@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 17:28:47 +0100
Message-Id: <1232209727.5987.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 17:12 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Dunno about the IO bits, but..
> >  
> > The problem with the C++ testcases seems to be wake_up_all() plunking a 
> > genuine thundering herd onto runqueues.  The sleeper fairness logic 
> > places the entire herd left of min_vruntime, meaning N*sched_latency 
> > pain for the poor sods who are setting the runqueue pace.
> 
> 100 wakeup pairs that all run and ping-pong between each other?
> 
> That creates 200 tasks with an average system load of 100.0, on a 
> dual-core system. Is that a fair representation of some real workload, or 
> just an unrealistic "gee, look, given enough tasks running I can overload 
> the system _this bad_" example?

Looks contrived to me, but it is a hole.  Dang sleepers, can't live with
'em can't live without 'em.

	-Mike

