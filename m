Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZHJUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZHJUhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZHJUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:37:11 -0400
Received: from bar.sig21.net ([80.81.252.164]:39213 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbZHJUhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:37:10 -0400
Date: Mon, 10 Aug 2009 22:37:06 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810203706.GA17338@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <87k51cgdt8.fsf@basil.nowhere.org>
 <20090810122731.GA5863@sig21.net>
 <20090810123228.GD6838@basil.fritz.box>
 <20090810125651.GB6082@sig21.net>
 <20090810132923.GA4418@elte.hu>
 <20090810192658.GA15513@sig21.net>
 <20090810201406.GA6961@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810201406.GA6961@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.324,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:14:06PM +0200, Ingo Molnar wrote:
> * Johannes Stezenbach <js@sig21.net> wrote:
> > 
> > # ./perf stat true
> > 
> >  Performance counter stats for 'true':
> > 
> >        0.985808  task-clock-msecs         #      0.779 CPUs 
> >               0  context-switches         #      0.000 M/sec
> >               0  CPU-migrations           #      0.000 M/sec
> >             110  page-faults              #      0.112 M/sec
> >          583873  cycles                   #    592.279 M/sec
> >          500937  instructions             #      0.858 IPC  
> >   <not counted>  cache-references        
> >   <not counted>  cache-misses            
> > 
> >     0.001265524  seconds time elapsed
> 
> That looks almost normal - except for cache-references and 
> cache-misses that is not counted. Could you send the /proc/cpuinfo 
> info please?

# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Pentium(R) M processor 1.80GHz
stepping	: 6
cpu MHz		: 600.000
cache size	: 2048 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips	: 1196.15
clflush size	: 64
power management:


> The warning is probably harmless - oprofile sampling still works 
> fine, right?

I haven't done much testing so far, but so far it looks promising.

Could the warning be caused by the cpufreq ondemand governor?
ISTR that one should switch to the performance governor before doing
any profiling, but I forgot for this test.


Johannes
