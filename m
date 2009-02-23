Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZBWSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZBWSYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBWSYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:24:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZBWSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:24:00 -0500
Date: Mon, 23 Feb 2009 13:23:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
 conversions
In-Reply-To: <20090223173108.GB1441@Krystal>
Message-ID: <alpine.DEB.2.00.0902231322370.18221@gandalf.stny.rr.com>
References: <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com> <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com>
 <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> 
> There is absolutely no link between stop_machine and text_poke. I argue
> against stop_machine saying that the breakpoint approach is less
> intrusive because it does not involve disabling interrupts for so long,
> and I argue against modifying the kernel page flags because that
> modifies the access rights of the core kernel and modules to RO

One correction. modules text is always mapped RW, event with 
CONFIG_DEBUG_RODATA. Perhaps we could fix that, but as it is today,
you do not need text_poke to modify module text.

-- Steve

> mappings, which is IMO a side-effect that we should eliminate _if we
> can_. Please keep those two concerns separate.

