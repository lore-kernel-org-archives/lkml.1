Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180Ab0AVAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0AVAdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952Ab0AVAdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:33:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922Ab0AVAdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:33:00 -0500
Date: Thu, 21 Jan 2010 16:31:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-Id: <20100121163145.7e958c3f.akpm@linux-foundation.org>
In-Reply-To: <20100121163004.8779bd69.akpm@linux-foundation.org>
References: <20100119211646.GF16096@redhat.com>
	<20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	<20100120054950.GB27108@elte.hu>
	<20100120061551.GB6588@in.ibm.com>
	<20100120062834.GB12165@elte.hu>
	<20100120072925.GA11395@elte.hu>
	<20100121013822.28781960.sfr@canb.auug.org.au>
	<20100122111747.3c224dfd.sfr@canb.auug.org.au>
	<20100121163004.8779bd69.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 16:30:04 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Someone please sell this to us.

Here's what Oleg said last time I asked this:

  First of all, utrace makes other things possible.  gdbstub,
  nondestructive core dump, uprobes, kmview, hopefully more.  I didn't
  look at these projects closely, perhaps other people can tell more.  As
  for their merge status, until utrace itself is merged it is very hard to
  develop them out of tree.

  To me, even seccomp is the good example why utrace is useful.  seccomp
  is simple, but it needs hooks in arch/ hot pathes.  Contrary,
  utrace-based implementation is more flexible, simple, and it is
  completely "hidden" behind utrace.

  In my opinion, ptrace-utrace is another example.  Once CONFIG_UTRACE
  goes away, we can remove almost all ptrace-related code from core kernel
  (and kill task_struct->ptrace/etc members).

  ftrace/etc is excellent in many ways, but even if we need the simple
  "passive" tracing it is not enough sometimes.  And we have nothing else
  except ptrace currently.  But ptrace is so horrible and unfixeable, and
  it has so many limitations.  In fact, even the simple things like stop/
  continue this thread/process are not trivial using ptrace, gdb/strace
  have to do a lot of hacks to overcome ptrace's limitations, and some of
  these hacks falls into "mostly works, but that is all" category.

  Of course, I can't promise we will have the new gdb which explores
  utrace facilities soon, but I think at least utrace gives a chance.

