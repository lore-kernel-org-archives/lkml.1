Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYHLBRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYHLBRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYHLBRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:17:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYHLBRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:17:19 -0400
Date: Mon, 11 Aug 2008 21:17:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: printk formatting infrastructure fix 2
In-Reply-To: <20080811162804.c437a761.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808112112480.32393@gandalf.stny.rr.com>
References: <200808062133.m76LXpGk016460@imap1.linux-foundation.org> <87zlnpueo9.fsf@skyscraper.fehenstaub.lan> <87fxpf4wbr.fsf@skyscraper.fehenstaub.lan> <20080811162804.c437a761.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, Andrew Morton wrote:

> On Fri, 08 Aug 2008 12:47:52 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:

> My attempts to generate a suitable config were not happy ones.  Feast
> your eyes upon this monstrosity:
> 
> Symbol: TRACING [=y]
> Selects: DEBUG_FS && STACKTRACE
> Selected by: FTRACE && HAVE_FTRACE || IRQSOFF_TRACER && TRACE_IRQFLAGS_SUPPORT && GENERIC_TIME && HAVE_FTRACE || PREEMPT_TRACER && GENERIC_TIME && PREEMPT && HAVE_FTRACE || SYSPROF_TRACER && X86 || SCHED_TRACER && HAVE_FTRACE || CONTEXT_SWITCH_TRACER && HAVE_FTRACE || MMIOTRACE && DEBUG_KERNEL && PCI
> 

This isn't as bad as it looks.

Yes tracing selects DEBUG_FS and STACKTRACE, but the TRACING is required 
to transcend into the kernel/trace directory. That is where the other 
tracers live, and some tracers require other options to be set.

ie. FTRACE requires HAVE_FTRACE, PREEMPT_TRACER requires PREEMPT, etc.

I don't really see a problem with those config dependencies.

-- Steve



