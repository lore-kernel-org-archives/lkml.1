Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZB1QiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZB1QiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZB1Qh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:37:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZB1Qh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:37:59 -0500
Date: Sat, 28 Feb 2009 17:56:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
Message-ID: <20090228165624.GC26292@one.firstfloor.org>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <20090227210856.GB1476@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227210856.GB1476@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 10:08:56PM +0100, Pavel Machek wrote:
> On Sun 2009-02-22 18:50:00, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > >
> > > Impact: keep kernel text read only
> > >
> > > Because dynamic ftrace converts the calls to mcount into and out of
> > > nops at run time, we needed to always keep the kernel text writable.
> > >
> > > But this defeats the point of CONFIG_DEBUG_RODATA. This patch converts
> > > the kernel code to writable before ftrace modifies the text, and converts
> > > it back to read only afterward.
> > >
> > > The conversion is done via stop_machine and no IPIs may be executed
> > > at that time. The kernel text is set to write just before calling
> > > stop_machine and set to read only again right afterward.
> > 
> > The very old text poke code I had for this just used a dynamic
> > mapping elsewhere instead to modify the code. That's much less
> > intrusive than changing the complete mappings. Any reason you can't use 
> > that too?
> 
> Is it legal to have two mappings of same page with different
> attributes? IIRC some processors did not like that...

If you mean PAT caching attributes: correct it is not legal in x86 and
causes problems including data corruption.
If you mean other attributes like large page vs small page: it's normally legal,
with a few exceptions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
