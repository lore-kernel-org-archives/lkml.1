Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZDWBdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZDWBdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZDWBcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:32:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3915 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZDWBcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:32:53 -0400
Subject: Re: RFC: introduce struct ksymbol
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090418160910.GA6212@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu>
	 <200904152021.41427.rusty@rustcorp.com.au>
	 <1239954933.31728.12.camel@localhost>  <20090418160910.GA6212@nowhere>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 18:31:46 -0700
Message-Id: <1240450306.21848.187.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 18:09 +0200, Frederic Weisbecker wrote:
> On Fri, Apr 17, 2009 at 12:55:33AM -0700, Joe Perches wrote:
> > On Wed, 2009-04-15 at 20:21 +0930, Rusty Russell wrote: 
> > > The current symbol printing APIs are awful; we should address them first
> > > (like the %pF patch does) IMHO.
> > I suggest just %pS<type>
> > With %pS, struct ksym is probably not all that
> > useful unless it's for something like a sscanf.
> > Today there are these symbol uses:
> > name, offset, size, modname
> > So perhaps %pS<foo> where foo is any combination of:
> > n name
> > o offset
> > s size
> > m modname
> > a all
> > and if not specified is a name lookup ("%pSn").
> It seems to me a rather good idea, it offers a good granularity
> about what has to displayed.

After implementing this %pS<foo> in a local tree,
I started to remove all print_symbol uses.

print_symbol is used in <foo>_warning_symbol calls.
These <foo>_warning_symbol uses seem dead.

Are they in use in some way or should they just
be removed?

see: http://lkml.org/lkml/2009/2/5/142

$ grep -r --include=*.[chS] -nH -e warning_symbol *
arch/x86/kernel/dumpstack.c:115:print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
arch/x86/kernel/dumpstack.c:145:	.warning_symbol = print_trace_warning_symbol,
arch/x86/kernel/stacktrace.c:17:save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
arch/x86/kernel/stacktrace.c:57:	.warning_symbol = save_stack_warning_symbol,
arch/x86/kernel/stacktrace.c:64:	.warning_symbol = save_stack_warning_symbol,
arch/x86/oprofile/backtrace.c:18:static void backtrace_warning_symbol(void *data, char *msg,
arch/x86/oprofile/backtrace.c:45:	.warning_symbol = backtrace_warning_symbol,
arch/x86/include/asm/stacktrace.h:11:	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
kernel/trace/trace_sysprof.c:64:backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
kernel/trace/trace_sysprof.c:93:	.warning_symbol		= backtrace_warning_symbol,



