Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbXEEQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbXEEQfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933933AbXEEQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:35:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48541 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900AbXEEQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:34:58 -0400
Date: Sat, 5 May 2007 14:14:44 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] mutex.h bogus __must_check (was Re: 2.6.21-mm1)
Message-ID: <20070505121444.GA28766@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
__must_check was added to mutex_lock_nested() which returns void. This
causes the following warnings:
include/linux/mutex.h:128: warning: 'warn_unused_result' attribute ignored

This was introduced by
broken-out/mutex_lock_interruptible-add-__must_check.patch

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 616500e..85e4225 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -124,8 +124,8 @@ extern void fastcall mutex_lock(struct mutex *lock);
 extern int fastcall mutex_lock_interruptible(struct mutex *lock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void __must_check mutex_lock_nested(struct mutex *lock,
-					unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock,
+			      unsigned int subclass);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 #else
