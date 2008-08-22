Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYHVGrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYHVGrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYHVGqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:46:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbYHVGqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:46:53 -0400
Date: Fri, 22 Aug 2008 08:46:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: warn on failure to disable mcount callers
Message-ID: <20080822064634.GU14110@elte.hu>
References: <alpine.DEB.1.10.0808201237210.27481@gandalf.stny.rr.com> <20080821084418.GJ28386@elte.hu> <alpine.DEB.1.10.0808211030300.20825@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808211030300.20825@gandalf.stny.rr.com>
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

> +			WARN_ON_ONCE(1);
> +			pr_info("ftrace faulted on modifying ");
> +			print_ip_sym(ip);
> +			break;
> +		case 2:
> +			WARN_ON_ONCE(1);
> +			pr_info("ftrace failed to modify ");
> +			print_ip_sym(ip);
> +			print_ip_ins(" expected: ", call);
> +			print_ip_ins(" actual: ", (unsigned char *)ip);
> +			print_ip_ins(" replace: ", nop);
> +			printk(KERN_CONT "\n");
> +			break;

hm, i think it makes little sense to only print out the stacktrace once, 
but to print out the rest all the time.

If there's such a failure then ftrace should warn once, with stacktrace 
and everthing else, and turn itself off permanently. That makes it sure 
that we 1) get the report 2) dont spam the user 3) keep the system 
working 4) turn off the malfunctioning component.

	Ingo
