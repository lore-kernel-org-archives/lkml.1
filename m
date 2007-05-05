Return-Path: <linux-kernel-owner+w=401wt.eu-S934319AbXEEScE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbXEEScE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934320AbXEEScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:32:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934319AbXEEScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:32:03 -0400
Date: Sat, 5 May 2007 11:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mutex.h bogus __must_check (was Re: 2.6.21-mm1)
Message-Id: <20070505113125.982930a9.akpm@linux-foundation.org>
In-Reply-To: <20070505121444.GA28766@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<20070505121444.GA28766@slug>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 14:14:44 +0200 Frederik Deweerdt <deweerdt@free.fr> wrote:

> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> __must_check was added to mutex_lock_nested() which returns void. This
> causes the following warnings:
> include/linux/mutex.h:128: warning: 'warn_unused_result' attribute ignored
> 
> This was introduced by
> broken-out/mutex_lock_interruptible-add-__must_check.patch

erp.  It was supposed to be on mutex_lock_interruptible():


--- a/include/linux/mutex.h~mutex_lock_interruptible-add-__must_check-must-fix
+++ a/include/linux/mutex.h
@@ -121,10 +121,10 @@ static inline int fastcall mutex_is_lock
  * Also see Documentation/mutex-design.txt.
  */
 extern void fastcall mutex_lock(struct mutex *lock);
-extern int fastcall mutex_lock_interruptible(struct mutex *lock);
+extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void __must_check mutex_lock_nested(struct mutex *lock,
+extern void mutex_lock_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
_

