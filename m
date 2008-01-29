Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYA2MEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYA2MEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYA2MEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:04:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43811 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbYA2MEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:04:14 -0500
Date: Tue, 29 Jan 2008 06:03:55 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129060355.7d38338f.pj@sgi.com>
In-Reply-To: <1201606284.28547.114.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<20080129040130.7b2904b6.pj@sgi.com>
	<1201603816.28547.94.camel@lappy>
	<20080129051353.4628c9eb.pj@sgi.com>
	<1201606284.28547.114.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, responding to Peter:
> > We now have a per-cpuset Boolean flag file called 'sched_load_balance'.
> 
> SD_LOAD_BALANCE, right?

No.  SD_LOAD_BALANCE is some attribute of sched domains.

The 'sched_load_balance' flag is an attribute of cpusets.

The mapping of cpusets to sched domains required several pages of 'fun
to write' code, which had to go through a couple of years of fixing and
one major rewrite before it (knock on wood) worked correctly.  It's not
a one-to-one relation, in other words.  See my earlier messages for
further explanation of how this works.

I'm not sure what SD_LOAD_BALANCE does ... I guess from a quick
read that it just optimizes the recognition of singleton sched
domains for which load balancing would be a wasted effort.


> > This 'sched_load_balance' flag is, thus far, "the" cpuset hook
> > supporting realtime.  One can use it to configure a system so that
> > the kernel does not do normal load balancing on select CPUs, such
> > as those CPUs dedicated to realtime use.
> 
> Ah, here I disagree, it is possible to do (hard) realtime scheduling
> over multiple cpus, the only draw back is that it requires a very strong
> load-balancer, making it unsuitable for large number of cpus.

I don't think we are disagreeing.  I was speaking of "normal"
load balancing (what the mainline kernel/sched.c code normally
does).  You're speaking of hard realtime load balancing.

I think we agree that these both exist, and require different
load balancing code, the latter 'very strong.'

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
