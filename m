Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZBTR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZBTR4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZBTR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:56:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZBTR4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:56:24 -0500
Date: Fri, 20 Feb 2009 18:55:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090220175535.GN24538@elte.hu>
References: <20090220163846.709775139@goodmis.org> <20090220164045.827841413@goodmis.org> <20090220173035.GI24538@elte.hu> <alpine.DEB.2.00.0902201247220.13747@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902201247220.13747@gandalf.stny.rr.com>
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

> > > +/* used by ftrace */
> > > +void set_kernel_text_rw(void)
> > 
> > i'd leave out the 'used by ftrace' bit - more uses might 
> > arise. How does kprobes get around readonly pages, it uses 
> > these APIs too, right?
> 
> kprobes uses text_poke. text_poke uses vmap to create its own 
> page table pointers to the text memory, does the modification 
> and then removes the pointers. This is quite heavy weight and 
> since ftrace needs to modify 10s of thousands of areas, 
> converting all of kernel text page tables is much more 
> efficient.
> 
> Note, if kprobes did change the original page tables, then it 
> too would have hit the split_large_page bug too.

i think the real reason is that kprobes was written before we 
had this more flexible and more usable CPA code.

	Ingo
