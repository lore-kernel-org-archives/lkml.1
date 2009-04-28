Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbZD1P0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbZD1P0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbZD1PWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:22:53 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:53075 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762555AbZD1PWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:22:51 -0400
Message-ID: <49F71F4A.3080908@oracle.com>
Date: Tue, 28 Apr 2009 08:22:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] lockd: fix FILE_LOCKING=n build error
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au>
In-Reply-To: <20090428165343.2e357d7a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49F71EFE.008F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

lockd/svclock.c is missing a header file <linux/fs.h>.

<linux/fs.h> is missing a definition of locks_release_private()
for the config case of FILE_LOCKING=n, causing a build error:

fs/lockd/svclock.c:330: error: implicit declaration of function 'locks_release_private'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/lockd/svclock.c |    1 +
 include/linux/fs.h |    4 ++++
 2 files changed, 5 insertions(+)

--- linux-next-20090428.orig/fs/lockd/svclock.c
+++ linux-next-20090428/fs/lockd/svclock.c
@@ -22,6 +22,7 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
--- linux-next-20090428.orig/include/linux/fs.h
+++ linux-next-20090428/include/linux/fs.h
@@ -1183,6 +1183,10 @@ static inline void locks_remove_flock(st
 	return;
 }
 
+static inline void locks_release_private(struct file_lock *fl)
+{
+}
+
 static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	return;

-- 
~Randy
