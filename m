Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXDGRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXDGRxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXDGRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:53:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631AbXDGRxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:53:39 -0400
Date: Sat, 7 Apr 2007 10:53:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
Message-Id: <20070407105328.836902d1.akpm@linux-foundation.org>
In-Reply-To: <46178ECC.2030107@googlemail.com>
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
	<46178ECC.2030107@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 14:30:04 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> akpm@linux-foundation.org napisał(a):
> > The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
> > 
> > It contains the following patches against 2.6.21-rc6:
> > 
> 
> LTP triggered a ptrace problem.
> 
> ------------[ cut here ]------------
> kernel BUG at kernel/ptrace.c:1281!

umm, Roland, if you're going to add assertions which only function with
CONFIG_PREEMPT enabled, you'd better test with CONFIG_PREEMPT enabled ;)


From: Andrew Morton <akpm@linux-foundation.org>

We hold read_lock(tasklist_lock) in here.

Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/ptrace.c~utrace-fix-bug kernel/ptrace.c
--- a/kernel/ptrace.c~utrace-fix-bug
+++ a/kernel/ptrace.c
@@ -1278,8 +1278,6 @@ found:
 		 current->pid, tsk->pid, p->pid, exit_code,
 		 p->exit_state, p->exit_signal);
 
-	NO_LOCKS;
-
 	/*
 	 * If there was a group exit in progress, all threads report that
 	 * status.  Most will have SIGKILL in their own exit_code.
_


