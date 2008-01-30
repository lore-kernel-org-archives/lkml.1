Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYA3N0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYA3N0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYA3NZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:25:56 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:18404 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYA3NZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:25:56 -0500
Message-ID: <47A079BD.8020106@siemens.com>
Date: Wed, 30 Jan 2008 14:21:01 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
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
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
References: <20080130031521.258552785@goodmis.org> <20080130031840.337019504@goodmis.org>
In-Reply-To: <20080130031840.337019504@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> --- linux-mcount.git.orig/arch/x86/kernel/entry_32.S	2008-01-29 16:59:15.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/entry_32.S	2008-01-29 17:26:18.000000000 -0500
> @@ -75,6 +75,31 @@ DF_MASK		= 0x00000400 
>  NT_MASK		= 0x00004000
>  VM_MASK		= 0x00020000
>  
> +#ifdef CONFIG_MCOUNT
> +.globl mcount
> +mcount:
> +	/* unlikely(mcount_enabled) */
> +	cmpl $0, mcount_enabled
> +	jnz trace
> +	ret

(and the corresponding 64-bit version)

Is the impact of this change on the (already expensive) mcount_enabled
case negligible? I worried about use cases where we want to gain some
(relative) worst-case numbers via these instrumentations.

In my personal priority scheme, CONFIG_MCOUNT=y && !mcount_enabled comes
after mcount_enabled.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
