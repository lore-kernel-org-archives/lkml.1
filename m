Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYDVKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYDVKXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbYDVKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:23:33 -0400
Received: from simq2-qfe0.srvr.bell.ca ([206.47.199.152]:60992 "EHLO
	simq2-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbYDVKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:23:32 -0400
X-Greylist: delayed 2503 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 06:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUBAGVPDUicIs88/2dsb2JhbAAIimihIA
Message-ID: <480DB2DB.9040908@gmail.com>
Date: Tue, 22 Apr 2008 06:41:47 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git pull] scheduler changes for v2.6.26
References: <20080419181304.GB21353@elte.hu> <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu> <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
In-Reply-To: <20080421194359.GD8770@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Frans Pop <elendil@planet.nl> wrote:
> 
>>> It would be nice if you could try sched-devel/latest because it has 
>>> an improved ftrace "sched_switch" tracer where you can generate much 
>>> longer traces of this incident. Try the new /debug/trace_entries 
>>> runtime tunable.
>> I'll try to get the trace and will reply on the private thread we had. 
>> I may need additional instructions though.
> 
> you could also reply to this thread if you dont mind, so that others can 
> chime in too.
> 
> the 700-800 msecs of delays you see are very "brutal" so there must be 
> something fundamentally wrong going on here.
> 
> Could you first check (under sched-devel/latest) the quality of your 
> sched-clock, via running this script:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/tools/watch-rq-clock.sh
> 
> if you run it, it should output ~1000 msecs periods every second:
> 
>  europe:~> watch-rq-clock.sh
>  1002.115042
>  1005.509851
>  1004.187275
>  1004.409980
>  1004.430264
>  1004.445508
> 
> if it's way too 'slow', say it only 100 msecs per second, then the 
> scheduler clock is mis-measuring time and what the scheduler thinks to 
> be a 40 msecs delay might become a 400 msecs delay.
> 

Is this supposed to be true for everyone?

kevin@alekhine:~/linux$ uname -a
Linux alekhine 2.6.25-02519-g3925e6f #10 PREEMPT Sat Apr 19 12:36:49 ADT 2008 x86_64 GNU/Linux

kevin@alekhine:~/linux$ ./watch-rq-clock.sh
89.986517
81.033471
76.942776
90.986318
75.988551
85.987089
74.988696
85.987078
73.988858
88.986641
68.989600

kevin@alekhine:~/linux$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 31
model name      : AMD Athlon(tm) 64 Processor 3000+
stepping        : 0
cpu MHz         : 1000.000
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow
rep_good lahf_lm
bogomips        : 2006.79
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Does that mean anything?  Is there any other testing I should perform?

-- 
Kevin Winchester
