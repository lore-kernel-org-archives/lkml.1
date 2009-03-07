Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZCGU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZCGU1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZCGU10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:27:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZCGU1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:27:25 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 0/2] Syscalls tracing
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 07 Mar 2009 15:26:49 -0500
In-Reply-To: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> (Frederic Weisbecker's message of "Sat,  7 Mar 2009 05:52:58 +0100")
Message-ID: <y0mbpsdqdti.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> Here is a first attempt, quick one-shot, to provide a syscall tracing
> infrastructure on ftrace.

Please see also the utrace-based thread syscall/signal/lifecycle.
tracer I posted a few times, and is just about to be reposted as a
part of the larger utrace submission.

System call metadata (name, argument count, and getting fancier from
there) would be nice to have for other clients too, such as the audit
subsystem.

The main drawback of this general approach however is the notion that
ftrace is the solitary user of system call tracing, thus dedicating
that new task flag to this purpose.  Therefore, your code has nothing
like reference counting or sharing; nothing yet to avoid overhead on
threads that need no tracing, nor to allow more than one tracing
widget to consume events.  These are the sorts of services that utrace
provides.

- FChE
