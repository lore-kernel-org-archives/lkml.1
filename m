Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYHOJ3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYHOJ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYHOJ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:29:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYHOJ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:29:25 -0400
Date: Fri, 15 Aug 2008 11:28:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH 0/3] ftrace: handle kernel code remove
Message-ID: <20080815092844.GD22209@elte.hu>
References: <20080815024716.480118113@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815024716.480118113@goodmis.org>
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

> The dynamic ftrace feature keeps a table of all the places that call 
> mcount to either disable them (replacing them with nops) or to enable 
> them (calling some trace function).
> 
> This table of functions is also displayed to the user interface to let 
> users enable or disable specific functions. This allows users to only 
> trace some functions within the kernel.
> 
> When a module or init sections are removed, the pointers to their 
> locations still exist in this table.  To protect against faults and 
> writing over other text, fault handling and code comparing is done. 
> When the code is update, the code being replaced is calculated and 
> compared to the actual text that is being replaced, if the code does 
> not match what is expected to be there, the change is not made.
> 
> There is a very small chance that the wrong text (or perhaps a data 
> section) could match the call to mcount and an inappropriate 
> modification could be made.
> 
> This patch series adds ftrace_release, to allow a module to remove the 
> pointers to the mcount callers in the module from this table.
> 
> Also, __init has "notrace" added to it so that text in the init 
> section are not traced. The trace currently can not be enabled until 
> after init anyway, so this should not be a problem.

applied to tip/tracing/ftrace - thanks Steve! I merged it into 
tip/master and started testing it.

	Ingo
