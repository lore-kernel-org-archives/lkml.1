Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZDNJUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZDNJUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZDNJUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:20:40 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:52292 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZDNJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:20:38 -0400
Date: Tue, 14 Apr 2009 11:20:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, torvalds@linux-foundation.org,
       linux-next@vger.kernel.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090414112034.568aa3f8@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090414.015727.173707436.davem@davemloft.net>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
	<20090414.015727.173707436.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 01:57:27 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 14 Apr 2009 14:43:17 +1000
> 
> > Dave, arch/sparc/include/asm/atomic_32.h should really include
> > asm/system.h since xchg is used in there.
> 
> That's true.
> 
> But atomic.h is not the proper place to obtain xchg() from, which is
> asm/system.h, and that's what debug_locks.h needs to include if it
> needs to use xchg().
> 
> This is why the s390 build broke in precisely the same way.

Due to header include dependencies we can't include asm/system.h from
asm/atomic.h. So David's solution seems to be the right way.
How about this:

Subject: [PATCH] Fix xchg build breakage on s390.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In file included from kernel/panic.c:11:
include/linux/debug_locks.h: In function '__debug_locks_off':
include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'

Caused by 9eeba6138cefc0435695463ddadb0d95e0a6bcd2
"lockdep: warn about lockdep disabling after kernel taint"

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/linux/debug_locks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/debug_locks.h
===================================================================
--- linux-2.6.orig/include/linux/debug_locks.h
+++ linux-2.6/include/linux/debug_locks.h
@@ -2,7 +2,7 @@
 #define __LINUX_DEBUG_LOCKING_H
 
 #include <linux/kernel.h>
-#include <asm/atomic.h>
+#include <asm/system.h>
 
 struct task_struct;
 
