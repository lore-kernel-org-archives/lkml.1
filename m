Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYJQMlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYJQMlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYJQMlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:41:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:36619 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbYJQMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GcfxRyfnou/W52mC6sekUpCF7Hd/0n9D3UE4GmCLrrn17ci8b0DN4fN+zXR8+3nA5a
         bI2w0HBOLcMQ/eP7zXK6b74HIlfTGBctO3LopBzR2Bg0hdBmyPYTGTU5FFsobcZG3m8e
         ZPfOvltwUB2snosmig2BC0m9OEOAoaBeguz+M=
Date: Fri, 17 Oct 2008 16:44:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/31] proc: remove remnants of ->read_proc in proc_misc.c
Message-ID: <20081017124418.GK22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 8917de6b832590da04b3b1531fc2b6810955d8ab Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 14:30:53 +0400
Subject: [PATCH 10/31] proc: remove remnants of ->read_proc in proc_misc.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 2cc8288..2dbe0aa 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,24 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-/*
- * Warning: stuff below (imported functions) assumes that its output will fit
- * into one page. For some of those functions it may be wrong. Moreover, we
- * have a way to deal with that gracefully. Right now I used straightforward
- * wrappers, but this needs further analysis wrt potential overflows.
- */
-
-static int proc_calc_metrics(char *page, char **start, off_t off,
-				 int count, int *eof, int len)
-{
-	if (len <= off+count) *eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len>count) len = count;
-	if (len<0) len = 0;
-	return len;
-}
-
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -622,15 +604,6 @@ struct proc_dir_entry *proc_root_kcore;
 
 void __init proc_misc_init(void)
 {
-	static struct {
-		char *name;
-		int (*read_proc)(char*,char**,off_t,int,int*,void*);
-	} *p, simple_ones[] = {
-		{NULL,}
-	};
-	for (p = simple_ones; p->name; p++)
-		create_proc_read_entry(p->name, 0, NULL, p->read_proc, NULL);
-
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-- 
1.5.6.5

