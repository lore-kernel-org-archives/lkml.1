Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbZL3Lat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbZL3Lat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZL3Las
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:30:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZL3Lar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:30:47 -0500
Date: Wed, 30 Dec 2009 12:30:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
Message-ID: <20091230113031.GA22095@elte.hu>
References: <4B27702F.1080507@cn.fujitsu.com>
 <20091215142325.GC5833@nowhere>
 <4B30C2D1.4030006@cn.fujitsu.com>
 <4B30C3A0.909@cn.fujitsu.com>
 <20091228075417.GB20039@elte.hu>
 <4B3991C1.6060303@cn.fujitsu.com>
 <1262164786.7135.166.camel@laptop>
 <20091230092830.GA18190@elte.hu>
 <1262165789.7135.170.camel@laptop>
 <1262167566.7135.189.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262167566.7135.189.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> OK so there is no sysconf() syscall and its all implemented in glibc, which 
> is utter suckage.. will have to come up with something saner then.

I think integrating it into the perf stream of events would be the most 
desirable approach - tooling could make use of it easily.

For data record (and hierarchy) description /debug/tracing/events/ would be 
useful.

We dont want to actually 'activate' them in an 'event' fashion - but we could 
use event IDs and the record format and the transport to describe and recover 
the values.

For transport we could use the mmap ring-buffer and it would also be nice to 
add (or resurrect) some 'quick & easy' read()/write() based transport. It a 
bit like a value read-out from a counter - just here it's not a regular 
counter but some sort of kernel-internal value that we want to provide.

Hm?

	Ingo
