Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZLDUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZLDUtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZLDUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:48:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbZLDUsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:48:46 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 08/15] ima: valid return code from ima_inode_alloc
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk, jmorris@namei.org, npiggin@suse.de,
       eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Date: Fri, 04 Dec 2009 15:47:44 -0500
Message-ID: <20091204204744.18286.52076.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_inode_alloc returns 0 and 1, but the LSM hooks expects an errno.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_iint.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index a4e2b1d..4a53f39 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -87,8 +87,6 @@ out:
 /**
  * ima_inode_alloc - allocate an iint associated with an inode
  * @inode: pointer to the inode
- *
- * Return 0 on success, 1 on failure.
  */
 int ima_inode_alloc(struct inode *inode)
 {
@@ -99,7 +97,7 @@ int ima_inode_alloc(struct inode *inode)
 
 	iint = ima_iint_insert(inode);
 	if (!iint)
-		return 1;
+		return -ENOMEM;
 	return 0;
 }
 

