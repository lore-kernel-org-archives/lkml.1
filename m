Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0BTOWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:22:35 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:64012 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0BTOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G4cV1Gw62HZUk7At7/MpumWpe9hj7DvDh5dBv8cH2vTH0RvNs76K79byk7S6ZbRBwp
         Oq1+xREK0vKuYz8UZmDYqUDi6fvo8LU2udR6qz3b/3cB575eC9qMFIn4qLusf3GFTicb
         VRkmmwzXtQkaoWqxDqSjCZMplkXiOZ4beJVAw=
Date: Sat, 20 Feb 2010 22:22:24 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andi Kleen <ak@linux.intel.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] sysctl extern cleanup - poll
Message-ID: <20100220142224.GP3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move epoll_table extern declaration to linux/poll.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/poll.h |    3 +++
 kernel/sysctl.c      |    4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/poll.h	2010-02-20 14:02:15.871592994 +0800
+++ linux-2.6.32/include/linux/poll.h	2010-02-20 14:44:14.138009487 +0800
@@ -12,6 +12,9 @@
 #include <linux/fs.h>
 #include <asm/uaccess.h>
 
+#if defined(CONFIG_EPOLL) && defined (CONFIG_SYSCTL)
+extern struct ctl_table epoll_table[];
+#endif
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
 #define MAX_STACK_ALLOC 832
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:41:41.625522844 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:43:20.458847237 +0800
@@ -65,6 +65,7 @@
 #include <linux/acct.h>
 #include <linux/rtmutex.h>
 #include <linux/lockdep.h>
+#include <linux/poll.h>
 #include <scsi/sg.h>
 
 #include <asm/uaccess.h>
@@ -162,9 +163,6 @@ extern struct ctl_table random_table[];
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
-#ifdef CONFIG_EPOLL
-extern struct ctl_table epoll_table[];
-#endif
 
 /* The default sysctl tables: */
 
