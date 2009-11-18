Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZKRJbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZKRJbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZKRJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:31:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:54307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbZKRJbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:31:35 -0500
Subject: Re: [PATCH 3/7 v6] perf/core: Add a callback to perf events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20091118001815.GA8187@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
	 <1257694141-5670-4-git-send-email-fweisbec@gmail.com>
	 <1258457333.7816.186.camel@laptop>  <20091118001815.GA8187@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 10:31:09 +0100
Message-ID: <1258536669.3918.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 01:18 +0100, Frederic Weisbecker wrote:
> On Tue, Nov 17, 2009 at 12:28:53PM +0100, Peter Zijlstra wrote:
> > On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> > > A simple callback in a perf event can be used for multiple purposes.
> > > For example it is useful for triggered based events like hardware
> > > breakpoints that need a callback to dispatch a triggered breakpoint
> > > event.
> > > 
> > > v2: Simplify a bit the callback attribution as suggested by Paul
> > >     Mackerras
> > 
> > Yuck! So we add an opaque callback without semantics nor usage.
> 
> 
> Yeah, this is intended for events that need to be able to trigger
> events to different channels. In the case of hw-breakpoints, it's
> either perf buffer, ptrace, etc...
> 
> Should I add some comments about it?

At the very least.. describe its semantics and preferably rename the
thing.

Currently I've no clue what it does and why, your description above
about multiple channels does not at all help me understand how this
function pointer is used to make that happen.

