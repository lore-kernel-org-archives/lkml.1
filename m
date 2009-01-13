Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZAMC65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZAMC65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZAMC6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:58:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:47225 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751749AbZAMC6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:58:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xe0wSSLoxC8T1SBWtSJC/oRa8zFPt9PXojXNCcd
	Dbpuo1CDSQmGAA
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <496BE8F6.1040308@xyzw.org>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 03:58:43 +0100
Message-Id: <1231815523.5899.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 17:05 -0800, Brian Rogers wrote:
> Ingo Molnar wrote:
> > i've applied your fix to tip/sched/urgent and merged it into tip/master.
> > Brian, you might want to test tip/master, as per:
> >
> >  http://people.redhat.com/mingo/tip.git/README
> >
> > which now has this fix included. Can you make it break?
> >   
> Yeah, I was able to trigger the same freeze again once on my desktop, 
> but it appears to be harder to trigger now. I couldn't get my program to 
> freeze the system, but one of the times I suspended then resumed BOINC, 
> it happened.

Drat.

> While experimenting on my laptop, things got into a funny state where 
> konsole froze, then gnome-terminal froze, so I just started launching 
> xterms. pgrep and pidof would freeze and never terminate. ps axl froze 
> after listing process 23681, which was a BOINC process. The next 
> process, 23682, was another BOINC process. Going into /proc/23682 and 
> running ls -l as root froze the shell. I figured out that ls -l exe was 
> enough to freeze it. I couldn't shut down BOINC because process 23682 
> wouldn't close, and kill -9 did nothing to it. top, which actually did 
> work, showed that process just continuing to run with around 100% CPU 
> time. I had to power cycle the system.
> 
> I'll try Mike's "more complete" patch on top of 2.6.29-rc1 and see what 
> that does.

Don't bother.  I just tried a SCHED_IDLE make -j8 and had character
repeats while typing.  Must be another spot.

	-Mike

