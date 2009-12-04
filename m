Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZLDWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZLDWin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZLDWim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:38:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZLDWil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:38:41 -0500
Message-ID: <4B198FE7.2080408@gmail.com>
Date: Fri, 04 Dec 2009 23:40:39 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: bfields@fieldses.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 23/31] Constify struct nlmsvc_binding for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct nlmsvc_binding.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 fs/lockd/svc.c             |    2 +-
 fs/nfsd/lockd.c            |    2 +-
 include/linux/lockd/bind.h |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 1a54ae1..6a16c27 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -43,7 +43,7 @@
 
 static struct svc_program	nlmsvc_program;
 
-struct nlmsvc_binding *		nlmsvc_ops;
+const struct nlmsvc_binding *	nlmsvc_ops;
 EXPORT_SYMBOL_GPL(nlmsvc_ops);
 
 static DEFINE_MUTEX(nlmsvc_mutex);
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index b2786a5..f717a27 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -67,7 +67,7 @@ nlm_fclose(struct file *filp)
 	fput(filp);
 }
 
-static struct nlmsvc_binding	nfsd_nlm_ops = {
+static const struct nlmsvc_binding	nfsd_nlm_ops = {
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
 };
diff --git a/include/linux/lockd/bind.h b/include/linux/lockd/bind.h
index fbc48f8..0886e57 100644
--- a/include/linux/lockd/bind.h
+++ b/include/linux/lockd/bind.h
@@ -23,13 +23,13 @@ struct svc_rqst;
  * This is the set of functions for lockd->nfsd communication
  */
 struct nlmsvc_binding {
-	__be32			(*fopen)(struct svc_rqst *,
+	__be32			(* const fopen)(struct svc_rqst *,
 						struct nfs_fh *,
 						struct file **);
-	void			(*fclose)(struct file *);
+	void			(* const fclose)(struct file *);
 };
 
-extern struct nlmsvc_binding *	nlmsvc_ops;
+extern const struct nlmsvc_binding *	nlmsvc_ops;
 
 /*
  * Similar to nfs_client_initdata, but without the NFS-specific

