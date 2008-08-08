Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYHHQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYHHQ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:28:18 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49490 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHHQ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:28:17 -0400
Date: Fri, 8 Aug 2008 19:26:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] uninline nfsd4_op_name()
Message-ID: <20080808162642.GG14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be a compelling reason why nfsd4_op_name() is 
marked as "inline":

It's only used in a dprintk(), and as long as it has only one caller 
non-ancient gcc versions anyway inline it automatically.

This patch fixes the following compile error with gcc 3.4:

<--  snip  -->

...
  CC      fs/nfsd/nfs4proc.o
nfs4proc.c: In function `nfsd4_proc_compound':
nfs4proc.c:854: sorry, unimplemented: inlining failed in call to 
nfs4proc.c:897: sorry, unimplemented: called from here
make[3]: *** [fs/nfsd/nfs4proc.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -851,7 +851,7 @@ struct nfsd4_operation {
 
 static struct nfsd4_operation nfsd4_ops[];
 
-static inline char *nfsd4_op_name(unsigned opnum);
+static char *nfsd4_op_name(unsigned opnum);
 
 /*
  * COMPOUND call.
@@ -1116,8 +1116,7 @@ static struct nfsd4_operation nfsd4_ops[OP_RELEASE_LOCKOWNER+1] = {
 	},
 };
 
-static inline char *
-nfsd4_op_name(unsigned opnum)
+static char *nfsd4_op_name(unsigned opnum)
 {
 	if (opnum < ARRAY_SIZE(nfsd4_ops))
 		return nfsd4_ops[opnum].op_name;

