Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZKELDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZKELDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZKELDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:03:43 -0500
Received: from ozlabs.org ([203.10.76.45]:41647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZKELDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:03:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19186.45320.518439.831011@cargo.ozlabs.ibm.com>
Date: Thu, 5 Nov 2009 22:03:36 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
In-Reply-To: <1257275474-5285-5-git-send-email-fweisbec@gmail.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	<1257275474-5285-5-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> @@ -207,6 +212,15 @@ struct perf_event_attr {
>  		__u32		wakeup_events;	  /* wakeup every n events */
>  		__u32		wakeup_watermark; /* bytes before wakeup   */
>  	};
> +
> +	union {
> +		struct { /* Hardware breakpoint info */
> +			__u64		bp_addr;
> +			__u32		bp_type;
> +			__u32		bp_len;
> +		};
> +	};

I'm wondering why you don't use attr.config for anything with
breakpoint events?

Paul.
