Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYHNTzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYHNTzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYHNTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:54:58 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:49571 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYHNTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:54:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAEwlpEhMRKxB/2dsb2JhbACBYrVsgVU
Date: Thu, 14 Aug 2008 15:49:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080814194954.GA11028@Krystal>
References: <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A46897.4040900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A46897.4040900@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:39:42 up 71 days, 20 min,  8 users,  load average: 0.68, 0.92,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Sure, here are the updated tables. Basically, they show no significant
>> difference between the NOP and the DS segment selector prefix
>> approaches.
>
> Actually, unless I have blown my T-test completely, they show with a 80% 
> and 74% confidence (respective for the two benchmarks) that the DS case is 
> slightly *better* (0.26% and 0.20% better, respective), which makes it a 
> no-brainer.  Doing around 10 runs of each is likely to confirm this 
> conclusion by pushing it into the 90+% interval.
>

I did more runs (20 runs of each) to compare the nop case to the DS
prefix case. Results in seconds. They actually does not seems to show a
significant difference.

NOP

34.155
33.955
34.012
35.299
35.679
34.141
33.995
35.016
34.254
33.957
33.957
34.008
35.013
34.494
33.893
34.295
34.314
34.854
33.991
34.132

DS

34.080
34.304
34.374
35.095
34.291
34.135
33.940
34.208
35.276
34.288
33.861
33.898
34.610
34.709
33.851
34.256
35.161
34.283
33.865
35.078

Used http://www.graphpad.com/quickcalcs/ttest1.cfm?Format=C to do the
T-test (yeah, I'm lazy) :

 Group      Group One (DS prefix)       Group Two (nops)
 Mean                    34.37815               34.37070
 SD                       0.46108                0.51905
 SEM                      0.10310                0.11606
 N                             20                     20       

P value and statistical significance:
  The two-tailed P value equals 0.9620
  By conventional criteria, this difference is considered to be not
  statistically significant.

Confidence interval:
  The mean of Group One minus Group Two equals 0.00745
  95% confidence interval of this difference: From -0.30682 to 0.32172 

Intermediate values used in calculations:
  t = 0.0480
  df = 38
  standard error of difference = 0.155 

So, unless these calculus are completely bogus, the difference between
the nop and the DS case seems not to be statistically significant.

Mathieu


> Note that since the difference is so small, and so can also be due to some 
> kind of systematic error (lower ambient temperature during the DS run 
> making the disk drive slightly faster, what have you.)
>
> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
