Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZCYDsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZCYDsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZCYDsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:48:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbZCYDsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:48:17 -0400
Date: Tue, 24 Mar 2009 23:48:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces - v2
In-Reply-To: <20090325033001.GA20411@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0903242342230.22830@gandalf.stny.rr.com>
References: <20090324152028.754123712@K.Prasad> <20090324152811.GL17918@in.ibm.com> <alpine.DEB.2.00.0903242256280.22830@gandalf.stny.rr.com> <20090325033001.GA20411@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, K.Prasad wrote:
> 
> Thanks for pointing that out. I will make those changes and send out a
> new patchset.
> 
> However, looking at some of the existing plugins I find that many of
> them do this check after trace_assign_type() or not do at all (e.g.
> trace_branch_print()). They may need similar changes too.

Ah, that was the other option I was going to mention. The 
trace_branch_print is not called by tracer->print_line, like you have. 
What you did is not wrong, but there are other options.

The other option is to register an event callback. That is, the ftrace 
infrastructure will call the event registered to an id. I register 
the trace_branch_event with the TRACE_BRANCH id. Then the ftrace 
infrastructure will call the trace_branch_print if it encounters the 
TRACE_BRANCH entry.

This means you can do the UNHANDLED return as I suggested. Or you remove 
the print_line from you tracer and register an event for TRACE_KSYM 
instead.

The choice is up to you ;-)

-- Steve

