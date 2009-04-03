Return-Path: <linux-kernel-owner+w=401wt.eu-S1764620AbZDCLb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764620AbZDCLb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbZDCLbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:31:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761120AbZDCLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:31:17 -0400
Date: Fri, 3 Apr 2009 13:30:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/18] x86, bts: fix race when bts tracer is removed
Message-ID: <20090403113058.GE31399@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145702.669790000@intel.com> <20090402184514.GC843@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E9271804B@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77E9271809B@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9271809B@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Metzger, Markus T
> >Sent: Friday, April 03, 2009 8:20 AM
> >To: Ingo Molnar
> 
> 
> >>Also, raw use of jiffies_64 is buggy and racy. Why does this use
> >>jiffies to begin with - why not some finer grained time?
> >
> >What would be a good time to use?
> 
> I found cpu_clock() declared in sched.h, which is based on TSC and 
> seems to be used by the scheduler, as well. Would this be a good 
> time to use?

i'd suggest trace_clock() [which maps to cpu_clock() internally], or 
trace_clock_global().

See kernel/trace/trace_clock.c about the properties/tradeoffs. Since 
this is a user-facing ABI, trace_clock_global() looks more 
compelling, despite its global lock.

	Ingo
