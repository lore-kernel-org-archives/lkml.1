Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYA2MpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYA2MpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbYA2Moy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:44:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182AbYA2Mox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:44:53 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
In-Reply-To: <20080129060355.7d38338f.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	 <20080129040130.7b2904b6.pj@sgi.com> <1201603816.28547.94.camel@lappy>
	 <20080129051353.4628c9eb.pj@sgi.com> <1201606284.28547.114.camel@lappy>
	 <20080129060355.7d38338f.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 13:30:04 +0100
Message-Id: <1201609804.28547.137.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 06:03 -0600, Paul Jackson wrote:
> Paul, responding to Peter:
> > > We now have a per-cpuset Boolean flag file called 'sched_load_balance'.
> > 
> > SD_LOAD_BALANCE, right?
> 
> No.  SD_LOAD_BALANCE is some attribute of sched domains.
> 
> The 'sched_load_balance' flag is an attribute of cpusets.
> 
> The mapping of cpusets to sched domains required several pages of 'fun
> to write' code, which had to go through a couple of years of fixing and
> one major rewrite before it (knock on wood) worked correctly.  It's not
> a one-to-one relation, in other words.  See my earlier messages for
> further explanation of how this works.

Ok, I'll take a stab at understanding that code. Perhaps it seems to me
a lot of confusion could be solved by getting a more level playing
ground :-)

> > > This 'sched_load_balance' flag is, thus far, "the" cpuset hook
> > > supporting realtime.  One can use it to configure a system so that
> > > the kernel does not do normal load balancing on select CPUs, such
> > > as those CPUs dedicated to realtime use.
> > 
> > Ah, here I disagree, it is possible to do (hard) realtime scheduling
> > over multiple cpus, the only draw back is that it requires a very strong
> > load-balancer, making it unsuitable for large number of cpus.
> 
> I don't think we are disagreeing.  I was speaking of "normal"
> load balancing (what the mainline kernel/sched.c code normally
> does).  You're speaking of hard realtime load balancing.
> 
> I think we agree that these both exist, and require different
> load balancing code, the latter 'very strong.'

Great :-)



