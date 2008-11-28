Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYK1J0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYK1J0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYK1J0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:26:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbYK1J0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:26:04 -0500
Date: Fri, 28 Nov 2008 10:25:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
	trace informations
Message-ID: <20081128092553.GA7040@elte.hu>
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128091800.GA1725@elte.hu>
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


another thing which i'm sure you are aware of:

# tracer: function_graph
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
 ------------------------------------------
 | 1)  S99local--1  =>  ssh-1724
 ------------------------------------------
 
 1)      0.867 us |        }
 1)               |        mark_page_accessed() {
 1)      0.293 us |          constant_test_bit();
 1)      0.294 us |          constant_test_bit();
[...]

the header description is now out of of sync :-)

Also, we should probably not start the trace with a PID-switch event. 
the last_pid[] markers are probably out of sync when we start printing 
the trace.

So the output should probably be something like:

# tracer: function_graph
#
# CPU      COST     FUNCTION-GRAPH
# |          |       |        

 1)      0.867 us |        }
 1)               |        mark_page_accessed() {
 1)      0.293 us |          constant_test_bit();
 1)      0.294 us |          constant_test_bit();
[...]

	Ingo
