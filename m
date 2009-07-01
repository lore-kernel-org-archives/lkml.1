Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZGAOQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZGAOQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZGAOP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:15:59 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46103 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZGAOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:15:58 -0400
Subject: Re: [tip:tracing/urgent] tracing: Fix trace_print_seq()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-5c37f525657e879a17a27c83021602cd55837531@git.kernel.org>
References: <4A4B2351.5010300@cn.fujitsu.com>
	 <tip-5c37f525657e879a17a27c83021602cd55837531@git.kernel.org>
Date: Wed, 01 Jul 2009 17:15:59 +0300
Message-Id: <1246457759.20817.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 14:06 +0000, tip-bot for Xiao Guangrong wrote:
> Commit-ID:  5c37f525657e879a17a27c83021602cd55837531
> Gitweb:     http://git.kernel.org/tip/5c37f525657e879a17a27c83021602cd55837531
> Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> AuthorDate: Wed, 1 Jul 2009 16:50:25 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 1 Jul 2009 16:03:50 +0200
> 
> tracing: Fix trace_print_seq()
> 
> We will lose something if trace_seq->buffer[0] is 0, because the copy length
> is calculated by strlen() in seq_puts(), so using seq_write() instead of
> seq_puts().
> 
> There have a example:
> after reboot:
> 
>  # echo kmemtrace > current_tracer
>  # echo 0 > options/kmem_minimalistic
>  # cat trace
>  # tracer: kmemtrace
>  #
>  #
> 
> Nothing is exported, because the first byte of trace_seq->buffer[ ]
> is KMEMTRACE_USER_ALLOC.
> 
> ( the value of KMEMTRACE_USER_ALLOC is zero, seeing
>   kmemtrace_print_alloc_user() in kernel/trace/kmemtrace.c)
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> LKML-Reference: <4A4B2351.5010300@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Nice catch!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

