Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZB1OB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZB1OB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZB1OBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:01:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZB1OBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:01:50 -0500
Date: Fri, 27 Feb 2009 22:08:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20090227210856.GB1476@ucw.cz>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6vyuzsn.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-02-22 18:50:00, Andi Kleen wrote:
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

Is it legal to have two mappings of same page with different
attributes? IIRC some processors did not like that...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
