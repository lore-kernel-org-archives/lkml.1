Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYLPUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYLPUEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYLPUEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:04:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44316 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYLPUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:04:42 -0500
Date: Tue, 16 Dec 2008 21:04:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20081216200427.GA1890@ucw.cz>
References: <20081214212829.GA9435@elte.hu> <20081216122229.GA1430@ucw.cz> <20081216125000.GC25019@elte.hu> <20081216125720.GC1684@ucw.cz> <20081216130302.GA27678@elte.hu> <20081216141330.1943c30d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216141330.1943c30d@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-16 14:13:30, Arjan van de Ven wrote:
> On Tue, 16 Dec 2008 14:03:02 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > >  - plus you have to forbid SMT CPUs as well. On HT a task could
> > > >    co-schedule with your setuid task and observe its timing
> > > >    characteristics via its _own_ behavior. (which is impacted by
> > > > whatever is running on another SMT/HT thread.)  
> > > 
> > > Yes, SMT is evil.  
> > 
> > HT got added back to Nehalem, so SMT is coming to you in every future
> > x86 CPU. It brings a serious performance win, so nobody will turn
> > off

Fortunately, Intel is not the only x86 vendor :-).

> > SMT threading in practice. If SMT worries you, it needs explicit
> > partitioning of security-relevant processing to different physical
> > CPUs, via cgroups/cpusets/etc.

I guess we should refuse to run threads from different uids on one
physical core...

> and/or you use properly implemented crypto code (see Bruce Schneider's
> books). The timing "problem" isn't really SMT specific. If you have
> improperly implemented crypto (eg crypto code where the code paths and
> not just the data payload are key dependent) then on any system with
> more than one (logical) processor there is interference that an
> attacker can use.
> 
> The only possible answer is to use proper implementation; turning off HT
> may make you feel good but you go from shoddy crypto for which there is
> some internet papers on how to crack it, to shoddy crypto for which the
> same papers apply ;)

It is not only timing. If attacker has access to detailed cache miss
statistics, things are easier for him... I probably should review the
books, but even if code paths are key-independend (hard), you'll get
timing differences due to [data] cache misses...?

Ok, this is getting off-topic.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
