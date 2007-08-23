Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXHWIpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXHWIpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXHWIpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:45:09 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:61472 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXHWIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:45:08 -0400
Date: Thu, 23 Aug 2007 13:48:17 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: jens.axboe@oracle.com
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Corrections in Documentation/block/ioprio.txt
Message-ID: <20070823081817.GA27439@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The newer glibc does not allow system calls to be made via _syscallN()
wrapper. They have to be made through syscall(). The ionice code used
the older interface. Correcting it to use syscall.

Signed-of-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


Index: linux-2.6.23-rc3-mm1/Documentation/block/ioprio.txt
===================================================================
--- linux-2.6.23-rc3-mm1.orig/Documentation/block/ioprio.txt	2007-07-09 05:02:17.000000000 +0530
+++ linux-2.6.23-rc3-mm1/Documentation/block/ioprio.txt	2007-08-23 13:23:28.000000000 +0530
@@ -86,8 +86,9 @@ extern int sys_ioprio_get(int, int);
 #error "Unsupported arch"
 #endif
 
-_syscall3(int, ioprio_set, int, which, int, who, int, ioprio);
-_syscall2(int, ioprio_get, int, which, int, who);
+#define ioprio_set(which, who, ioprio)  syscall(__NR_ioprio_set, which,\
+							who, ioprio)
+#define ioprio_get(which, who)	syscall(__NR_ioprio_get, which, who)
 
 enum {
 	IOPRIO_CLASS_NONE,

-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
