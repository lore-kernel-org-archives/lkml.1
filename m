Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0ALWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0ALWQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445Ab0ALWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0ALWQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:16:48 -0500
Date: Tue, 12 Jan 2010 17:15:54 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100112221554.GI4822@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com> <20100112045454.GJ5243@nowhere> <y0mhbqr40ja.fsf@fche.csb> <4B4CF0F4.3020706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4CF0F4.3020706@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > As you might expect, in systemtap we've had to figure out this area
> > some time ago.  We use another utrace consumer called "task finder" [...]
> 
> So, could you tell us how the task-finder works and is implemented?

The code may be found at runtime/task_finder* in the systemtap sources.
There is a simple interest-registration structure/API that identifies
processes / shared libraries of interest, and a set of callbacks to be
invoked when said processes/shared libraries are mapped or unmapped.

It is implemented in terms of utrace callbacks for process/thread
lifetime monitoring, and utrace syscall callbacks for tracking shared
library segments being mapped and unmapped.

http://sourceware.org/git/?p=systemtap.git;a=tree;f=runtime


> I think we'd better clarify what functions are required for uprobes
> and pmu, and I think we may be able to re-implement improved pmu on
> utrace.

I don't see any collision between pmu / perf / utrace, so nothing is
really "required" for them or simple usage of uprobes.  If you wish to
track dynamic process/shared-library lifetimes, then you need extra
code somewhere to respond to those changes.  Layering this dynamic
capability seems like the natural way to go, and is easily done with
utrace and/or tracepoints.

- FChE
