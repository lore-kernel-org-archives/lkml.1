Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZEJXGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZEJXGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZEJXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:06:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbZEJXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:06:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com
Cc: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC patch 00/20] Kernel tracing thread flag
In-Reply-To: Mathieu Desnoyers's message of  Saturday, 9 May 2009 12:22:09 -0400 <20090509162209.217414024@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
X-Shopping-List: (1) Despotic seduction string-art
   (2) Ostentatious detention
   (3) Judicious prostitutes
   (4) Spurious homogeneous beef
Message-Id: <20090510230435.B0E94FC35D@magilla.sf.frob.com>
Date: Sun, 10 May 2009 16:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suspect you will hit troubles with some arch's not having a bit to spare.
(Even on x86, it probably hurts several bytes of cache wastage to have to
use longer immediates in some 'test' instructions.)

Another direction to go for this is overloading TIF_SYSCALL_TRACE, so we do
not need any arch changes.  Before the end of the ptrace cleanup work that
Oleg is in the middle of, it should become simple to divorce ptrace's own
bookkeeping from TIF_SYSCALL_TRACE.  At that point, we just need a little
bit of cooperation (in generic non-arch code) to overload that bit for
multiple simultaneous purposes.


Thanks,
Roland
