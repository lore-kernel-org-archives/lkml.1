Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbZAQQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbZAQQh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZAQQhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:37:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:46816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756228AbZAQQhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:37:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4nWRMS7+41TDlAcMWNpMhws20qU4TAC7XARdgbu
	pjEpDR7JzzdGg7
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090117162519.GD10825@elte.hu>
References: <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
	 <1232198574.16303.8.camel@marge.simson.net>
	 <20090117160115.GA31601@elte.hu> <1232209281.5987.4.camel@marge.simson.net>
	 <20090117162519.GD10825@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 17:37:12 +0100
Message-Id: <1232210232.5987.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 17:25 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sat, 2009-01-17 at 17:01 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> > > > > scheduler regression.  It has been bisected.
> > > > 
> > > > Seems pretty clear.  I'd suggest reverting it.
> > > 
> > > We can revert it (and will revert it if no solution is found), but i'd 
> > > also like to understand why it happens, because that kind of 
> > > regression from this change is unexpected - we might be hiding some 
> > > bug that could pop up under less debuggable circumstances, so we need 
> > > to understand it while we have a chance.
> > 
> > Agree.  However, with the sched_mc stuff, mysql+oltp now does better 
> > with NEWIDLE on than off as well, as does an nfs kbuild.
> 
> Didnt you come up with the verdict that sched_mc=2 is not a win - or has 
> that changed? If we should change the defaults then please send a 
> re-tuning patch against the latest code.

sched_mc=2 was better than sched_mc=1.  The other balancing changes put
a dent in mysql+oltp peak and immediately after peak.  Setting
sched_mc=2 brought back the loss that was otherwise there all the way
through the curve back to 28 level, so with sched_mc=2, there was only
the slight loss of peak, and larger loss of post-peak.

> Still, the ping delays of multiple seconds are completely unacceptable and 
> need to be understood, or these will come back and might bite us in a lot 
> less fortunate place. NEWIDLE and WAKE_BALANCE has micro-effects on 
> latencies - anything in the user-visible range is highly anomalous at 
> these low load levels.
> 
> 	Ingo

