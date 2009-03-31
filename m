Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbZCaU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbZCaU5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZCaU5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:57:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbZCaU5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:57:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/utrace
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       oleg@redhat.com, adobriyan@gmail.com, mingo@elte.hu,
       torvalds@linux-foundation.org, fche@redhat.com, rostedt@goodmis.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: Christoph Hellwig's message of  Tuesday, 31 March 2009 12:25:04 -0400 <20090331162504.GA28442@infradead.org>
References: <20090321154501.GA2707@elte.hu>
	<20090321143413.75ead1aa.akpm@linux-foundation.org>
	<20090321215145.GB5262@redhat.com>
	<alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
	<20090322123749.GF19826@elte.hu>
	<20090323134813.GA18219@x200.localdomain>
	<20090323151400.GA3413@redhat.com>
	<20090323214417.GD5814@mit.edu>
	<20090330151844.8b4eed0f.akpm@linux-foundation.org>
	<1238491062.28248.2046.camel@twins>
	<20090331162504.GA28442@infradead.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090331205413.EDEFFFC2A8@magilla.sf.frob.com>
Date: Tue, 31 Mar 2009 13:54:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do have a really large objection of merging the current messy double
> ptrace implementation.  If current utrace based ptrace isn't 100% ready
> there's absolutely no point in merging it.  

There is no "current" utrace-ptrace implementation.  I haven't proposed
one for merging.  When one is ready and working, we can discuss its actual
technical details then.

> Other user would be even better, e.g. the seccomp rewrite.

The seccomp rewrite is a very simple user for which I have a prototype
patch.  (It needs testing, but that should be easy enough.)  The only
real complexity there is in deciding how to merge those changes.
Its components are:

* clean up Kconfig
* remove old arch/asm hooks
** mips
** powerpc
** sh
** sparc
** x86
* replace kernel/seccomp.c with utrace-based one

Except for the first one, doing it in small incremental changes would
leave some intermediate states with no seccomp feature usable in the
tree.  (And, of course, CONFIG_SECCOMP will require CONFIG_UTRACE
thereafter.)  Please advise on how many pieces to slice it into and
how to stage the merging.


Thanks,
Roland
