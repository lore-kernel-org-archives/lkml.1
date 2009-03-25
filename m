Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCYSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCYSgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZCYSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:35:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZCYSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:35:56 -0400
Date: Wed, 25 Mar 2009 19:35:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
	function struct
Message-ID: <20090325183513.GE28366@elte.hu>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu> <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com> <20090325174446.GE14250@elte.hu> <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com> <20090325180203.GB25518@elte.hu> <alpine.DEB.2.00.0903251411260.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251411260.5675@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> struct ftrace_profile {
> 	struct hlist_node	*node;
> 	unsigned long		ip;
> 	unsigned long		hit;
> 	unsigned long long	calltime;
> };
> 
> on x86_64 that is 40 bytes. (node is 16, ip is 8, hit is 8, calltime is 8)

node is a pointer so it's 8 bytes - so the whole thing is 32 bytes. 
Acceptable IMO - and could be compressed further if needed.

	Ingo
