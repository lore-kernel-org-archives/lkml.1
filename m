Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZDWHeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZDWHeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZDWH22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:28 -0400
Received: from sous-sol.org ([216.99.217.87]:48342 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755630AbZDWH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:26 -0400
Message-Id: <20090423072143.255015405@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>
Subject: [patch 007/100] ext4: fix typo which causes a memory leak on error path
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ext4-fix-typo-which-causes-a-memory-leak-on-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: a7b19448ddbdc34b2b8fedc048ba154ca798667b

This was found by smatch (http://repo.or.cz/w/smatch.git/)

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2693,7 +2693,7 @@ int ext4_mb_init(struct super_block *sb,
 	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
-		kfree(sbi->s_mb_maxs);
+		kfree(sbi->s_mb_offsets);
 		return -ENOMEM;
 	}
 

