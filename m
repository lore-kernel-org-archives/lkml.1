Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZLIFep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZLIFep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZLIFen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:34:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55796 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZLIFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:34:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH v3] [RFC] tracepoint: Add signal coredump tracepoint
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>
In-Reply-To: <20091208204007.31287.62096.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208104324.B589.A69D9226@jp.fujitsu.com> <20091208204007.31287.62096.stgit@dhcp-100-2-132.bos.redhat.com>
Message-Id: <20091209142322.F4C8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Dec 2009 14:34:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	TP_fast_assign(
> +		__entry->sig	= (int)cprm->signr;
> +		__entry->limit	= cprm->limit;
> +		__entry->flags	= cprm->mm_flags;
> +		__entry->retval	= retval;
> +		__assign_str(name,	core_name);
> +	),
> +
> +	TP_printk("sig=%d limit=%lu dumpable=0x%lx dump_filter=0x%lx "
> +		  "corename=\"%s\" retval=%d",
> +		  __entry->sig, __entry->limit,
> +		  __entry->flags & MMF_DUMPABLE_MASK,
> +		  (__entry->flags & MMF_DUMP_FILTER_MASK) >>
> +		  MMF_DUMP_FILTER_SHIFT,
> +		  __get_str(name), __entry->retval)
> +);
>  #endif /* _TRACE_SIGNAL_H */

I don't think "limit" is userfriendly name, core_limit or core_size_limit is better?
plus, we have core_pipe_limit sysctl too. (it's similar but different concept limit).

other parts looks good to me.



