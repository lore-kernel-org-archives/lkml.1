Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZEIPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZEIPjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZEIPi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:38:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZEIPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:38:58 -0400
Date: Sat, 9 May 2009 11:36:29 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509153629.GC29911@redhat.com>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509083737.GE3656@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, May 09, 2009 at 10:37:37AM +0200, Ingo Molnar wrote:
> [...]
> Firstly, it adds two new tracepoints to every system call. That is 
> unnecessary - we already have the TIF flag based callbacks, and we 
> can use the existing syscall attributes table to get to tracepoints 
> - without slow down (or impacting) the fast path in any way.
> [...]

However, as the TIF_SYSCALL_FTRACE and/or TIF_SYSCALL_TRACE flags are
tied to a single consumer, it would limit the usefulness of the
naturally multiple-client tracepoints, if they were made conditional
on them.  Would you be interested in a proper reference-counting API?

- FChE
