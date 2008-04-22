Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYDVJmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYDVJmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYDVJmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:42:43 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:11473 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbYDVJmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=dvJZdRHsRVYvWJuthlz0Gs+KzkDBFEKM252TTglmofYkOAEsgpU3J8MhuO4UszywrhALiGK8dPg6FznDeDFi0AqZgR7TiR4NetJWtq1Kj8R8OpTEg0CZaMfZ4qhMaZIIfLH1Dv9tlvILgRu2sxYP/FezAJLZcDSvdzvr+qNX8ww=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: remove unused parameter of xfs_qm_dqpurge
Date: Tue, 22 Apr 2008 11:42:00 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com>
In-Reply-To: <200804220514.45191.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oLbDI1pzHG1UDXj"
Message-Id: <200804221142.00914.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_oLbDI1pzHG1UDXj
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

xfs_qm_dqpurge() does not use flags parameter.
This patch removes it.

Code size difference on 32-bit x86:

# size */fs/xfs/xfs.o

Compile-tested only.
   text    data     bss     dec     hex filename
 390507    2748    1708  394963   606d3 linux-2.6-xfs3-TEST/fs/xfs/xfs.o
 390491    2748    1708  394947   606c3 linux-2.6-xfs4-TEST/fs/xfs/xfs.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_oLbDI1pzHG1UDXj
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs3-xfs_qm_dqpurge-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs3-xfs_qm_dqpurge-remove_unused_params.patch"

--- linux-2.6-xfs3/fs/xfs/quota/xfs_dquot.c	Tue Apr 22 04:06:46 2008
+++ linux-2.6-xfs4/fs/xfs/quota/xfs_dquot.c	Tue Apr 22 11:34:01 2008
@@ -1435,8 +1435,7 @@
 /* ARGSUSED */
 int
 xfs_qm_dqpurge(
-	xfs_dquot_t	*dqp,
-	uint		flags)
+	xfs_dquot_t	*dqp)
 {
 	xfs_dqhash_t	*thishash;
 	xfs_mount_t	*mp;
--- linux-2.6-xfs3/fs/xfs/quota/xfs_dquot.h	Tue Apr 22 04:06:46 2008
+++ linux-2.6-xfs4/fs/xfs/quota/xfs_dquot.h	Tue Apr 22 11:33:54 2008
@@ -164,7 +164,7 @@
 
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
-extern int		xfs_qm_dqpurge(xfs_dquot_t *, uint);
+extern int		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern int		xfs_qm_dqlock_nowait(xfs_dquot_t *);
 extern int		xfs_qm_dqflock_nowait(xfs_dquot_t *);
--- linux-2.6-xfs3/fs/xfs/quota/xfs_qm.c	Tue Apr 22 04:13:03 2008
+++ linux-2.6-xfs4/fs/xfs/quota/xfs_qm.c	Tue Apr 22 11:34:31 2008
@@ -631,7 +631,7 @@
 		 * freelist in INACTIVE state.
 		 */
 		nextdqp = dqp->MPL_NEXT;
-		nmisses += xfs_qm_dqpurge(dqp, flags);
+		nmisses += xfs_qm_dqpurge(dqp);
 		dqp = nextdqp;
 	}
 	xfs_qm_mplist_unlock(mp);

--Boundary-00=_oLbDI1pzHG1UDXj--
