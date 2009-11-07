Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZKGMQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZKGMQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 07:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZKGMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 07:16:47 -0500
Received: from www.tglx.de ([62.245.132.106]:44473 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZKGMQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 07:16:47 -0500
Date: Sat, 7 Nov 2009 13:16:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sparclinux@vger.kernel.org
Subject: Re: [patch 14/16] sparc: Replace old style lock initializer
In-Reply-To: <20091106.222032.02604670.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0911071310570.12138@localhost.localdomain>
References: <20091106223547.784916750@linutronix.de> <20091106223806.973326715@linutronix.de> <20091106.221834.246946954.davem@davemloft.net> <20091106.222032.02604670.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-934661253-1257596187=:12138"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-934661253-1257596187=:12138
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Nov 2009, David Miller wrote:

> From: David Miller <davem@davemloft.net>
> Date: Fri, 06 Nov 2009 22:18:34 -0800 (PST)
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 06 Nov 2009 22:42:14 -0000
> > 
> >> SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.
> >> 
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Applied to sparc-next-2.6, thanks.
> 
> This breaks the build:
> 
> /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/rwsem.h:39: error: expected identifier or ‘(’ before ‘{’ token
> /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/rwsem.h:39: error: expected identifier or ‘(’ before ‘}’ token
> make[1]: *** [arch/sparc/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Darn, I compiled it but the 32bit build does not use that file :)
Working version below.

Thanks,

	tglx
---
Subject: sparc: Replace old style lock initializer
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 06 Nov 2009 22:06:35 +0100

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/rwsem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -35,8 +35,8 @@ struct rw_semaphore {
 #endif
 
 #define __RWSEM_INITIALIZER(name) \
-{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, LIST_HEAD_INIT((name).wait_list) \
-  __RWSEM_DEP_MAP_INIT(name) }
+{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
+  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
--8323328-934661253-1257596187=:12138--
