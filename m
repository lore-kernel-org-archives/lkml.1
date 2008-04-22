Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYDVLvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYDVLvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYDVLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:51:45 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:62912 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYDVLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=EI0hh/hUcBrhEcM8aM3NZjrZv0f3MVYyiI+vALRbjmVLTv/9K3fZ6p+Zmr9SF4EwIlV6/rvS7y9P+N+YdeHIP3YSTbC6+UFAEX/3wiLiaMDvRp+5HkAP3PO1ONFNAWMM5UiaagPYfWgBClMejK8a+9DByKZw0jyePFULaxu2F+U=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: #define out unused parameters for seven functions in xfs_trans.h
Date: Tue, 22 Apr 2008 13:51:03 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221216.25905.vda.linux@googlemail.com> <200804221320.54147.vda.linux@googlemail.com>
In-Reply-To: <200804221320.54147.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nEdDIYaDy2GUb0P"
Message-Id: <200804221351.03885.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_nEdDIYaDy2GUb0P
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[ resend: now with patch attached! :) ]

Hi David,

Seven xfs_trans_XXX functions declared in xfs_trans.h
are not using "tp" parameter in non-debug builds,
but it still takes stack space since these functions
are not static and gcc cannot optimize it out.

This patch removes these parameters using #define hack
which makes them "disappear" without the need of uglifying
every callsite with #ifdefs.

Code size difference on 32-bit x86:
=9A393441 =9A =9A2904 =9A =9A2952 =9A399297 =9A 617c1 linux-2.6-xfs7-TEST/f=
s/xfs/xfs.o
=9A393289 =9A =9A2904 =9A =9A2952 =9A399145 =9A 61729 linux-2.6-xfs8-TEST/f=
s/xfs/xfs.o

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
=2D-
vda

--Boundary-00=_nEdDIYaDy2GUb0P
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs6-xfs_trans.h-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs6-xfs_trans.h-remove_unused_params.patch"

diff -urpN linux-2.6-xfs7/fs/xfs/xfs_trans_buf.c linux-2.6-xfs8/fs/xfs/xfs_trans_buf.c
--- linux-2.6-xfs7/fs/xfs/xfs_trans_buf.c	2008-04-22 04:06:44.000000000 +0200
+++ linux-2.6-xfs8/fs/xfs/xfs_trans_buf.c	2008-04-22 13:37:23.000000000 +0200
@@ -687,7 +687,6 @@ xfs_trans_bjoin(xfs_trans_t	*tp,
  * IOP_UNLOCK() routine is called.  The buffer must already be locked
  * and associated with the given transaction.
  */
-/* ARGSUSED */
 void
 xfs_trans_bhold(xfs_trans_t	*tp,
 		xfs_buf_t	*bp)
@@ -950,7 +949,6 @@ xfs_trans_stale_inode_buf(
  * xfs_buf_item_committed() to ensure that the buffer remains in the
  * AIL at its original location even after it has been relogged.
  */
-/* ARGSUSED */
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t	*tp,
@@ -979,7 +977,6 @@ xfs_trans_inode_alloc_buf(
  * between usr dquot bufs and grp dquot bufs, because usr and grp quotas
  * can be turned off independently.
  */
-/* ARGSUSED */
 void
 xfs_trans_dquot_buf(
 	xfs_trans_t	*tp,
diff -urpN linux-2.6-xfs7/fs/xfs/xfs_trans.h linux-2.6-xfs8/fs/xfs/xfs_trans.h
--- linux-2.6-xfs7/fs/xfs/xfs_trans.h	2008-04-22 13:10:36.000000000 +0200
+++ linux-2.6-xfs8/fs/xfs/xfs_trans.h	2008-04-22 13:41:38.000000000 +0200
@@ -961,6 +961,16 @@ struct xfs_buf	*xfs_trans_getsb(xfs_tran
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
+#ifndef DEBUG
+/* "tp" is used only for debugging */
+#define         xfs_trans_bhold(tp, bp)           xfs_trans_bhold(bp)
+#define         xfs_trans_bhold_release(tp, bp)   xfs_trans_bhold_release(bp)
+#define         xfs_trans_inode_buf(tp, bp)       xfs_trans_inode_buf(bp)
+#define         xfs_trans_stale_inode_buf(tp, bp) xfs_trans_stale_inode_buf(bp)
+#define         xfs_trans_inode_alloc_buf(tp, bp) xfs_trans_inode_alloc_buf(bp)
+#define         xfs_trans_dquot_buf(tp, bp, type) xfs_trans_dquot_buf(bp, type)
+#define         xfs_trans_ihold(tp, bp)           xfs_trans_ihold(bp)
+#endif
 void		xfs_trans_bhold(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
diff -urpN linux-2.6-xfs7/fs/xfs/xfs_trans_inode.c linux-2.6-xfs8/fs/xfs/xfs_trans_inode.c
--- linux-2.6-xfs7/fs/xfs/xfs_trans_inode.c	2008-04-22 04:12:18.000000000 +0200
+++ linux-2.6-xfs8/fs/xfs/xfs_trans_inode.c	2008-04-22 13:38:10.000000000 +0200
@@ -224,7 +224,6 @@ xfs_trans_ijoin(
  * IOP_UNLOCK() routine is called.  The inode must already be locked
  * and associated with the given transaction.
  */
-/*ARGSUSED*/
 void
 xfs_trans_ihold(
 	xfs_trans_t	*tp,

--Boundary-00=_nEdDIYaDy2GUb0P--
