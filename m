Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbYHIBZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbYHIBZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYHIBZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:25:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64966 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYHIBZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:25:28 -0400
Date: Fri, 8 Aug 2008 21:25:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org>
 <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Aug 2008, Linus Torvalds wrote:
> 
> 
> On Fri, 8 Aug 2008, Jeremy Fitzhardinge wrote:
> >
> > Steven Rostedt wrote:
> > > I wish we had a true 5 byte nop. 
> > 
> > 0x66 0x66 0x66 0x66 0x90
> 
> I don't think so. Multiple redundant prefixes can be really expensive on 
> some uarchs.
> 
> A no-op that isn't cheap isn't a no-op at all, it's a slow-op.


A quick meaningless benchmark showed a slight perfomance hit.

Here's 10 runs of "hackbench 50" using the two part 5 byte nop:

run 1
Time: 4.501
run 2
Time: 4.855
run 3
Time: 4.198
run 4
Time: 4.587
run 5
Time: 5.016
run 6
Time: 4.757
run 7
Time: 4.477
run 8
Time: 4.693
run 9
Time: 4.710
run 10
Time: 4.715
avg = 4.6509


And 10 runs using the above 5 byte nop:

run 1
Time: 4.832
run 2
Time: 5.319
run 3
Time: 5.213
run 4
Time: 4.830
run 5
Time: 4.363
run 6
Time: 4.391
run 7
Time: 4.772
run 8
Time: 4.992
run 9
Time: 4.727
run 10
Time: 4.825
avg = 4.8264

# cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 65
model name	: Dual-Core AMD Opteron(tm) Processor 2220
stepping	: 3
cpu MHz		: 2799.992
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic 
cr8_legacy
bogomips	: 5599.98
clflush size	: 64
power management: ts fid vid ttp tm stc

There's 4 of these.

Just to make sure, I ran the above nop test again:

[ this is reverse from the above runs ]

run 1
Time: 4.723
run 2
Time: 5.080
run 3
Time: 4.521
run 4
Time: 4.841
run 5
Time: 4.696
run 6
Time: 4.946
run 7
Time: 4.754
run 8
Time: 4.717
run 9
Time: 4.905
run 10
Time: 4.814
avg = 4.7997

And again the two part nop:

run 1
Time: 4.434
run 2
Time: 4.496
run 3
Time: 4.801
run 4
Time: 4.714
run 5
Time: 4.631
run 6
Time: 5.178
run 7
Time: 4.728
run 8
Time: 4.920
run 9
Time: 4.898
run 10
Time: 4.770
avg = 4.757


This time it was close, but still seems to have some difference.

heh, perhaps it's just noise.

-- Steve

