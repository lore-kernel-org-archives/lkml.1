Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYLUKMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYLUKMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 05:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYLUKMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 05:12:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35410 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYLUKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 05:12:44 -0500
Date: Sun, 21 Dec 2008 11:12:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081221101226.GA6021@elte.hu>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu> <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain> <20081218112216.GE14332@elte.hu> <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com> <20081218211637.GF24271@elte.hu> <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com> <20081218214458.GA30834@elte.hu> <20081221100047.GA31074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221100047.GA31074@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> btw., a graph-tracer buglet i noticed:

another thing. I turned off all the options that come ahead of the 'meat' 
of the trace data:

# cat /debug/tracing/trace_options 
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock 
nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate 
nouserstacktrace nosym-userobj printk-msg-only nofuncgraph-overrun 
nofuncgraph-cpu nofuncgraph-overhead nofuncgraph-proc 

but i still got the 'duration' field printed:

# tracer: function_graph
#
# DURATION            FUNCTION CALLS
#     |               |   |   |   |

0.865 us    |    }
            |    alloc_page_vma() {
0.295 us    |      get_vma_policy();
0.268 us    |      policy_zonelist();
            |      __alloc_pages_internal() {
0.257 us    |        __might_sleep();
            |        get_page_from_freelist() {


i'd have expected to only see the flow of execution as it happens.

	Ingo
