Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbZHDKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbZHDKiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbZHDKiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:38:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbZHDKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:38:16 -0400
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Dave Anderson <anderson@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A77DA98.6050509@cn.fujitsu.com>
References: <4A76F8A1.30503@cn.fujitsu.com>
	 <1249314136.7924.126.camel@twins>  <4A77DA98.6050509@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Aug 2009 12:36:52 +0200
Message-Id: <1249382212.7924.191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 14:52 +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-08-03 at 22:48 +0800, Lai Jiangshan wrote:
> >> + /* SIGH, we cann't get "print fmt" from core-file */
> > 
> > doesn't crash have a vmlinux around to look at?
> 
> 
> I don't known how to look at it:
> 
> static int								\
> ftrace_format_##call(struct trace_seq *s)				\
> {									\
> 	struct ftrace_raw_##call field __attribute__((unused));		\
> 	int ret = 0;							\
> 									\
> 	tstruct;							\
> 									\
> 	trace_seq_printf(s, "\nprint fmt: " print);			\
> 									\
> 	return ret;							\
> }
> 
> We need the address of the const string <"\nprint fmt: " print>,
> I don't know how to get it current from vmlinux.
> 
> I have sent a patch which try to reduce the size of .txt in kernel
> and reduce coupling. This patch has a little side-effect:
> the "print fmt"'s address is saved in struct ftrace_event_call.

Aah, right, I thought the fmt string was easily obtainable from the
_ftrace_events section, but now I see it is not, the patch you mention
below does indeed make it so.

> [
> http://lkml.org/lkml/2009/7/30/30
> 
> This patch is really useful for kernel. We don't change the kernel
> even a single line for the purpose of we can read the core-file easier.

Well, I see no harm in changing the kernel a little when it makes no
difference to the kernel but makes post-mortem analysis a little bit
easier.

> This patch is also helpful for crash more or less. So I mention it.
> ]

