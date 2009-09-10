Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZIJL2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZIJL2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZIJL2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:28:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49785 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZIJL2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:28:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19112.58078.764004.864248@cargo.ozlabs.ibm.com>
Date: Thu, 10 Sep 2009 21:28:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/5] perf_counter: Export various perf helpers for external users
In-Reply-To: <1252571367-25876-3-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
	<1252571367-25876-3-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> Export various perf helpers that initialize, destroy, attach and detach
> a perf counter for future external users like the hardware breakpoint api.

You are exporting things that are quite deep into the guts of the
perf_counter code, which makes me think that what you're exporting
isn't the right abstraction.  At the least, your commit message needs
to talk about what these external users want to do and why they need
to reach so deeply into the perf_counter internals.

> The allocation and initialization of a perf counter have been split up
> so that an external user can first allocate and then prefill the
> counter before initialize it properly.

Once again, this sounds like the wrong abstraction to me.  Can you
explain why first allocating and then prefilling it before
initializing it properly is necessary or desirable?

Paul.
