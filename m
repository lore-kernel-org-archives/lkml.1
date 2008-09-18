Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYIRWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYIRWVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYIRWVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:21:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944AbYIRWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:21:16 -0400
Date: Thu, 18 Sep 2008 15:20:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for September 18
Message-Id: <20080918152038.7b146f23.akpm@linux-foundation.org>
In-Reply-To: <20080918174108.3357c3d2.sfr@canb.auug.org.au>
References: <20080918174108.3357c3d2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 17:41:08 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)

Anyone using this kernel shold apply this x86 fix:

--- a/include/linux/uaccess.h~uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic
+++ a/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
+		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\
_

to prevent a storm of warnings like

[   58.694606] SLAB: cache with size 16384 has lost its name
[   58.694773] SLAB: cache with size 8192 has lost its name
[   58.694940] SLAB: cache with size 8192 has lost its name
[   58.695101] SLAB: cache with size 4096 has lost its name
[   58.695260] SLAB: cache with size 4096 has lost its name
[   58.695418] SLAB: cache with size 2048 has lost its name

plus probably other more nasty things.
