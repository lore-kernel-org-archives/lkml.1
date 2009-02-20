Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZBTSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZBTSAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZBTSAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:00:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZBTSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:00:32 -0500
Date: Fri, 20 Feb 2009 13:00:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace, x86: make kernel text writable only for
 conversions
In-Reply-To: <20090220175535.GN24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201259020.13747@gandalf.stny.rr.com>
References: <20090220163846.709775139@goodmis.org> <20090220164045.827841413@goodmis.org> <20090220173035.GI24538@elte.hu> <alpine.DEB.2.00.0902201247220.13747@gandalf.stny.rr.com> <20090220175535.GN24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > > +/* used by ftrace */
> > > > +void set_kernel_text_rw(void)
> > > 
> > > i'd leave out the 'used by ftrace' bit - more uses might 
> > > arise. How does kprobes get around readonly pages, it uses 
> > > these APIs too, right?
> > 
> > kprobes uses text_poke. text_poke uses vmap to create its own 
> > page table pointers to the text memory, does the modification 
> > and then removes the pointers. This is quite heavy weight and 
> > since ftrace needs to modify 10s of thousands of areas, 
> > converting all of kernel text page tables is much more 
> > efficient.
> > 
> > Note, if kprobes did change the original page tables, then it 
> > too would have hit the split_large_page bug too.
> 
> i think the real reason is that kprobes was written before we 
> had this more flexible and more usable CPA code.

I'm not saying that was the reason kprobes did it that way. I was just 
answering your question about how kprobes does it today ;-)

Perhaps it may be more efficient to convert kprobes to use the 
set_memory_rw/ro API now.

-- Steve

