Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZBFSBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZBFSBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBFSBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:01:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZBFSBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:01:20 -0500
Date: Fri, 6 Feb 2009 13:01:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: handle the leaf functions
 from trace_pipe
In-Reply-To: <498c7909.11355e0a.5fc7.4ff2@mx.google.com>
Message-ID: <alpine.DEB.1.10.0902061300540.22636@gandalf.stny.rr.com>
References: <498c7909.11355e0a.5fc7.4ff2@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Feb 2009, Frederic Weisbecker wrote:

> When one cat on the trace file, the leaf functions are printed without brackets:
> 
> function();
> 
> whereas in the trace_pipe file we'll see the following:
> 
> function() {
> }
> 
> This is because the ring_buffer handling is not the same between those two files.
> On the trace file, when an entry is printed, the iterator advanced and then we can
> check the next entry.
> 
> There is no iterator with trace_pipe, the current entry to print has been peeked
> and not consumed. So checking the next entry will still return the current one while
> we don't consume it.
> 
> This patch introduces a new value for the output callbacks to ask the tracing
> core to not consume the current entry after printing it.
> We need it because we will have to consume the current entry ourself to check the next one.
> 
> Now the trace_pipe is able to handle well the leaf functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks Frederic,

-- Steve

