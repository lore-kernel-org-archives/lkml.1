Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYFRH4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYFRH4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYFRHz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:55:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYFRHz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:55:56 -0400
Date: Wed, 18 Jun 2008 09:55:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Message-ID: <20080618075518.GD4135@elte.hu>
References: <200805252108.25011.mitov@issp.bas.bg> <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu> <200806152058.17142.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806152058.17142.mitov@issp.bas.bg>
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


* Marin Mitov <mitov@issp.bas.bg> wrote:

> Why not something like that (do keep in mind I am not an expert :-):
> 
> static void delay_tsc(unsigned long loops)
> {
> 	get and store the mask of allowed cpus;
> 	/*     prevent the migration   */
> 	set the mask of allowed cpus to the current cpu only;
> 	/*     is it possible? could it be guaranteed?    */
> 	loop for the delay;
> 	restore the old mask of allowed cpus;
> }
> 
> You have got the idea. Could it be realized? Is it more expensive than 
> the current realization? So, comments, please.

hm, changing/saving/restorig cpus_allowed is really considered a 'heavy' 
operation compared to preempt_disable(). On a 4096 CPUs box cpus_allowed 
is 4096 bits which is half a kilobyte ...

preempt_disable()/enable() on the other hand only touches a single 
variable, (thread_info->preempt_count which is an u32)

	Ingo
