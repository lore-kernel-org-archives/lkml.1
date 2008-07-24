Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYGXX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYGXX4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYGXX4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:56:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51845 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYGXX4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:56:13 -0400
Date: Fri, 25 Jul 2008 02:55:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [2.6 patch] fix fs/nfs/nfsroot.c compilation
Message-ID: <20080724235549.GB19310@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit f9247273cb69ba101877e946d2d83044409cc8c5
(UFS: add const to parser token tabl):

<--  snip  -->

...
  CC      fs/nfs/nfsroot.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/nfs/nfsroot.c:130: error: tokens causes a section type conflict
make[3]: *** [fs/nfs/nfsroot.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
75623185c608ee0d223a0076ea8237edcb8ac18f 
diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index 46763d1..8478fc2 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -127,7 +127,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t __initdata tokens = {
+static match_table_t __initconst tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rsize, "rsize=%u"},
 	{Opt_wsize, "wsize=%u"},

