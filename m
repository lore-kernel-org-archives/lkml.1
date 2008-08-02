Return-Path: <linux-kernel-owner+w=401wt.eu-S1761843AbYHBTkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761843AbYHBTkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761176AbYHBTdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:33:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:50389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761155AbYHBTdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=RXm0t3NQ5eBwyoW1pZAe0Ip+5kHknaLmCDGi12W6U2VPkfq2qgtbMIGbPDl3K03YWR
         vkbgMq/XZAI53inIEymfsCMq+Li5ONgVhUquS+x5L1ZBU9sdoBycALGeNCHwWgwWySjS
         i4rJpzGSk8ddOxV8IwUyvmGOmvblNzXlZQfp0=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Hugh Dickins <hugh@veritas.com>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1] exec: remove some includes
Date: Sat, 2 Aug 2008 21:45:17 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022145.17161.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ba92a43dbaee339cf5915ef766d3d3ffbaaf103c Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hugh@veritas.com>
Date: Fri, 25 Jul 2008 01:45:43 -0700
Subject: [PATCH] exec: remove some includes

[ Upstream commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c ]

fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.

[akpm@linux-foundation.org: unbreak arm]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/exec.c b/fs/exec.c
index 190ed1f..e41aef0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -25,19 +25,18 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
-#include <linux/mman.h>
+#include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
+#include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
-#include <linux/swap.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -47,7 +46,6 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
-#include <linux/rmap.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
