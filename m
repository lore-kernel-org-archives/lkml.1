Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZKELLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZKELLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZKELLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:11:48 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38054 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZKELLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:11:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BlROt0agF9fsaPn7rQVggZrf82Evd5EVpQg1I2vZxZoGKQEO+pYcpJh2e5r2w/TXSp
         hkUhCCOYxIolaPi5u/3DF4YrGs9xfPUAexLz5F1dKsODgTi3e9D+395DL2XLpruZEpCJ
         /i64MM+gNrSHa2nEh8k1Pft58dzUy/Ne2cv/M=
Date: Thu, 5 Nov 2009 12:11:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
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
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091105111151.GC4877@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <19186.45320.518439.831011@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19186.45320.518439.831011@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:03:36PM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > @@ -207,6 +212,15 @@ struct perf_event_attr {
> >  		__u32		wakeup_events;	  /* wakeup every n events */
> >  		__u32		wakeup_watermark; /* bytes before wakeup   */
> >  	};
> > +
> > +	union {
> > +		struct { /* Hardware breakpoint info */
> > +			__u64		bp_addr;
> > +			__u32		bp_type;
> > +			__u32		bp_len;
> > +		};
> > +	};
> 
> I'm wondering why you don't use attr.config for anything with
> breakpoint events?
> 
> Paul.


Because this is not sufficient to host the breakpoint parameters
given from userspace. May be I'm missing something?

