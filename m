Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXKJJgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXKJJgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 04:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXKJJf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 04:35:58 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58176 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXKJJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 04:35:57 -0500
Date: Sat, 10 Nov 2007 15:04:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       dada1@cosmosbay.com, davem@davemloft.net, apw@shadowen.org
Subject: [PATCH] 2.6.24-rc2-git1 Build fails in selinux/hooks.
Message-ID: <20071110093440.GA24410@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.24-rc2-git1 kernel build fails, with following error

  CC      security/selinux/hooks.o
In file included from include/net/tcp.h:35,
                 from security/selinux/hooks.c:52:
include/net/inet_hashtables.h: In function 'inet_ehash_locks_alloc':
include/net/inet_hashtables.h:165: error: implicit declaration of function 'vmalloc'
include/net/inet_hashtables.h:165: warning: assignment makes pointer from integer without a cast
include/net/inet_hashtables.h: In function 'inet_ehash_locks_free':
include/net/inet_hashtables.h:186: error: implicit declaration of function 'vfree'
make[2]: *** [security/selinux/hooks.o] Error 1
make[1]: *** [security/selinux] Error 2
make: *** [security] Error 2

The commit 230140cffa7feae90ad50bf259db1fa07674f3a7 ([INET]: Remove per
bucket rwlock in tcp/dccp ehash table.) caused this build
failure.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 8461cda..624ddbf 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/vmalloc>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_sock.h>

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
