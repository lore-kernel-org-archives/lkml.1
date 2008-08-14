Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYHNSJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYHNSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHNSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:09:47 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:41475 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYHNSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:09:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAGQNpEhMRKxB/2dsb2JhbACBYrUigVU
Date: Thu, 14 Aug 2008 14:09:43 -0400
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
Message-ID: <20080814180943.GD4697@Krystal>
References: <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A46897.4040900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A46897.4040900@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:57:20 up 70 days, 22:37,  7 users,  load average: 0.18, 0.68,
	0.71
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

Yes, I think you are right.

> Note that since the difference is so small, and so can also be due to some 
> kind of systematic error (lower ambient temperature during the DS run 
> making the disk drive slightly faster, what have you.)
>

I doubt it, because I made a "cache priming" run before the tests, which
made sure the data was all populated in memory. But yeah, having
different cpu clock calibration values/cpu clock frequency between
reboots could also cause that kind of difference.

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
