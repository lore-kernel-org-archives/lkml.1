Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYIZXRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYIZXRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYIZXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:16:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:42765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYIZXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:16:52 -0400
Date: Fri, 26 Sep 2008 16:16:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
Message-ID: <20080926161654.4ce08913@infradead.org>
In-Reply-To: <1222456633.16700.292.camel@lappy.programming.kicks-ass.net>
References: <20080925185154.230259579@goodmis.org>
	<20080925185236.244343232@goodmis.org>
	<alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
	<48DC406D.1050508@redhat.com>
	<alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	<1222456633.16700.292.camel@lappy.programming.kicks-ass.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 21:17:13 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
> > +#define CHECK_COND(buffer, cond)                       \
> > +       if (unlikely(cond)) {                           \
> > +               atomic_inc(&buffer->record_disabled);   \
> > +               WARN_ON(1);                             \
> > +               return -1;                              \
> > +       }
> 
> Arjan, any preferences wrt kerneloops.org?

this works; if you also want to print something use WARN() instead

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
