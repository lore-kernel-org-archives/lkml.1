Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbZD3U32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbZD3U32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbZD3U3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:29:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZD3U3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:29:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: do not use task->ptrace directly in core kernel
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 14:28:27 +0200 <20090429122827.GA27838@redhat.com>
References: <20090429122827.GA27838@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090430202828.8A763FC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 13:28:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is fine, but doesn't buy much.  i.e., we will be changing these again
before too long anyway I imagine.

I added task_ptrace() just for tracehook.h use, really.  There it drives
the event hooks.  Those uses are directly obsoleted by using another event
hooking mechanism such as utrace.  That applies to ptrace_signal() too.
But the other uses will be replaced by something different later, not just
go away.

The BUG_ON cases might as well just go away, probably.

The exit.c cases might be clearer if we give them a (trivial) local helper
with a more topical name like task_wait_inhibited().

ptrace_fork() is a wrapper that just calls arch_ptrace_fork(), which itself
is an empty macro on most configurations.  I think we might as well just
make ptrace_fork() an inline in linux/ptrace.h and put the test inside it.
(Thus any future changes touch ptrace.h and not fork.c.)


Thanks,
Roland
