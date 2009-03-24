Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZCXN71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZCXN71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZCXN7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:59:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZCXN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:59:14 -0400
Date: Tue, 24 Mar 2009 14:58:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] function-graph: ignore times across schedule
Message-ID: <20090324135833.GB32043@elte.hu>
References: <20090324135422.026619569@goodmis.org> <20090324135610.441707783@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324135610.441707783@goodmis.org>
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

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: more accurate timings
> 
> The current method of function graph tracing does not take into
> account the time spent when a task is not running. This shows functions
> that call schedule have increased costs:
> 
>  3) + 18.664 us   |      }
>  ------------------------------------------
>  3)    <idle>-0    =>  kblockd-123
>  ------------------------------------------
> 
>  3)               |      finish_task_switch() {
>  3)   1.441 us    |        _spin_unlock_irq();
>  3)   3.966 us    |      }
>  3) ! 2959.433 us |    }
>  3) ! 2961.465 us |  }

dunno - i actually like how it shows the _real_ elapsed time. Why is 
this wrong?

	Ingo
