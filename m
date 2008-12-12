Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYLLV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYLLV57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbYLLV4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:56:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbYLLV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:56:50 -0500
Date: Fri, 12 Dec 2008 16:56:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
In-Reply-To: <20081212213538.GA731@localhost>
Message-ID: <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
 <20081212213538.GA731@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 13 Dec 2008, Cyrill Gorcunov wrote:

> [Steven Rostedt - Fri, Dec 12, 2008 at 04:22:49PM -0500]
> ...
> | > Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
> | > ===================================================================
> | > --- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
> | > +++ linux-2.6.git/arch/x86/include/asm/ftrace.h
> | > @@ -1,6 +1,33 @@
> | >  #ifndef _ASM_X86_FTRACE_H
> | >  #define _ASM_X86_FTRACE_H
> | >  
> | > +#ifdef __ASSEMBLY__
> | 
> | Why add assembly condition? We only want this if CONFIG_FUNCTION_TRACER 
> | is enabled, right?  We could combine it with the current #ifndef inside 
> | the CONFIG_FUNCTION_TRACER. But I would make do:
> | 
> | #ifdef __ASSEMBLY__
> | <your stuff>
> | #else
> | < C stuff >
> | #endif
> | 
> | -- Steve
> 
> Steve, here is how it could look like:
> (I liked first proposal more :)

I see the confusion. In ftrace.h the function graph tracer config is not 
inside CONFIG_FUNCTION_TRACER, even though it is dependent on it (or 
was). OK, just do your first proposal then.

-- Steve

