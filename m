Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZBVWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZBVWxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZBVWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZBVWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:53:09 -0500
Date: Sun, 22 Feb 2009 17:53:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
 conversions
In-Reply-To: <87y6vyuzsn.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Sun, 22 Feb 2009, Andi Kleen wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Impact: keep kernel text read only
> >
> > Because dynamic ftrace converts the calls to mcount into and out of
> > nops at run time, we needed to always keep the kernel text writable.
> >
> > But this defeats the point of CONFIG_DEBUG_RODATA. This patch converts
> > the kernel code to writable before ftrace modifies the text, and converts
> > it back to read only afterward.
> >
> > The conversion is done via stop_machine and no IPIs may be executed
> > at that time. The kernel text is set to write just before calling
> > stop_machine and set to read only again right afterward.
> 
> The very old text poke code I had for this just used a dynamic
> mapping elsewhere instead to modify the code. That's much less
> intrusive than changing the complete mappings. Any reason you can't use 
> that too?
> 

We are changing over 19000 locations in the kernel. This touches almost 
all kernel text pages anyway. You want to map a page in and out for over 
19000 locations?

-- Steve

