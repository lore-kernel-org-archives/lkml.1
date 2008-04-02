Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYDBE2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYDBE2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYDBE2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:28:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYDBE2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:28:30 -0400
Date: Tue, 1 Apr 2008 21:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sapan Bhatia" <sapan.bhatia@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel@hozac.com
Subject: Re: race leading to held mutexes, inode_cache corruption
Message-Id: <20080401212820.7e6c3519.akpm@linux-foundation.org>
In-Reply-To: <3cb76b010804012113p1758addsbfaea2882280b082@mail.gmail.com>
References: <3cb76b010804011815l52e69576x9ddb97c07ab38111@mail.gmail.com>
	<20080401183829.110ae2b9.akpm@linux-foundation.org>
	<3cb76b010804012113p1758addsbfaea2882280b082@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 00:13:04 -0400 "Sapan Bhatia" <sapan.bhatia@gmail.com> wrote:

> >
> >
> > That's the only way in which I can interpret your second paragraph, but as
> > far as I can tell the code cannot do that.
> >
> > Can you provide more detail?
> >
> 
> On running the example again, it seems that attributing the problem to a
> generic locking bug was a misdiagnosis. I apologize for the misinformation.
> The error is more likely a path with a dangling mutex_lock somewhere, or
> something else. I'll investigate further and try to provide a more detailed
> description of the problem when I have something concrete.
> 

OK, thanks.

Recent kernels have this:

config DEBUG_LOCK_ALLOC
	bool "Lock debugging: detect incorrect freeing of live locks"
	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
	select DEBUG_SPINLOCK
	select DEBUG_MUTEXES
	select LOCKDEP
	help
	 This feature will check whether any held lock (spinlock, rwlock,
	 mutex or rwsem) is incorrectly freed by the kernel, via any of the
	 memory-freeing routines (kfree(), kmem_cache_free(), free_pages(),
	 vfree(), etc.), whether a live lock is incorrectly reinitialized via
	 spin_lock_init()/mutex_init()/etc., or whether there is any lock
	 held during task exit.

which seems rather relevant, no? ;)
