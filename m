Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYBERMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYBERMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYBERMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:12:40 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:35616 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbYBERMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:12:38 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47A89704.9000504@am.sony.com>
Date: Tue, 05 Feb 2008 09:04:04 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 14/23 -v8] Add tracing of context switches
References: <20080130210357.927754294@goodmis.org> <20080130210527.028868510@goodmis.org>
In-Reply-To: <20080130210527.028868510@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 17:07:50.0879 (UTC) FILETIME=[A3A156F0:01C86819]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Index: linux-mcount.git/lib/tracing/Kconfig
> ===================================================================
> --- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-30 15:18:18.000000000 -0500
> +++ linux-mcount.git/lib/tracing/Kconfig	2008-01-30 15:32:33.000000000 -0500
> @@ -23,3 +23,12 @@ config FUNCTION_TRACER
>  	  insert a call to an architecture specific __mcount routine,
>  	  that the debugging mechanism using this facility will hook by
>  	  providing a set of inline routines.
> +
> +config CONTEXT_SWITCH_TRACER
> +	bool "Trace process context switches"
> +	depends on DEBUG_KERNEL
> +	select TRACING
> +	help
> +	  This tracer hooks into the context switch and records
> +	  all switching of tasks.
> +

This needs a "select MARKERS" or it doesn't compile.

My config has:

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_EVENT_TRACER is not set
# CONFIG_WAKEUP_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y

   -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

