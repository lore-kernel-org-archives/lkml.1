Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbXEWPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbXEWPBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXEWPBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:01:24 -0400
Received: from holomorphy.com ([66.93.40.71]:53544 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765816AbXEWPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:01:23 -0400
Date: Wed, 23 May 2007 08:02:20 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523150220.GT19966@holomorphy.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:42:33AM -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> - A new readahead patch series.  This needs serious review and performance
>   testing please.
> - Added Ingo's CFS CPU scheduler
> - Xen dom-U support is now in the x86 tree.

The build fails with the following error when CONFIG_X86_MCE is not set:
arch/x86_64/kernel/built-in.o: In function `do_notify_resume':
/mnt/g/mm-2.6.22-rc2/arch/x86_64/kernel/signal.c:478: undefined reference to `mce_notify_user'
The following patch #ifdef's the offending call as a minimal fix.

Signed-off-by: William Irwin <bill.irwin@oracle.com>

Index: mm-2.6.22-rc2/arch/x86_64/kernel/signal.c
===================================================================
--- mm-2.6.22-rc2.orig/arch/x86_64/kernel/signal.c	2007-05-23 07:41:49.741705813 -0700
+++ mm-2.6.22-rc2/arch/x86_64/kernel/signal.c	2007-05-23 07:44:35.339142673 -0700
@@ -473,9 +473,11 @@
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+#ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
+#endif /* CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
