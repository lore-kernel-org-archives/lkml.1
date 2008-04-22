Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbYDVNle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbYDVNle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764261AbYDVNk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:40:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:1945 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764284AbYDVNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=GfR9NGsCppC3yyJ2CmJUOowzXf6vj27KelFCz99Bsec9UUBDkTI4P6R4vnvs5l3lDclhA/Az5q+O5pjNhxHz18dzprnhvY9HahmHn6XAY65/jr1gbcaqKvgd+So+9BJMZMruasETb1Qtm7mxTc3tjRn4WsnCZRSND4kfLDfRz44=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: remove unused params from functions in xfs/quota/*
Date: Tue, 22 Apr 2008 15:40:12 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221351.03885.vda.linux@googlemail.com> <200804221532.22701.vda.linux@googlemail.com>
In-Reply-To: <200804221532.22701.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8qeDIUYBL82VY1V"
Message-Id: <200804221540.12382.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8qeDIUYBL82VY1V
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

This patch deals with remaining cases of unused parameters in fs/xfs/quota/*
as far as I can see so far. The rest of unused parameters
in fs/xfs/quota/* cannot be easily eliminated due to addresses
of functions being taken.

Code size difference on 32-bit x86:
 393289    2904    2952  399145   61729 linux-2.6-xfs8-TEST/fs/xfs/xfs.o
 393236    2904    2952  399092   616f4 linux-2.6-xfs9-TEST/fs/xfs/xfs.o

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_8qeDIUYBL82VY1V
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs8-quota-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs8-quota-remove_unused_params.patch"

diff -urpN linux-2.6-xfs8/fs/xfs/quota/xfs_dquot.c linux-2.6-xfs9/fs/xfs/quota/xfs_dquot.c
--- linux-2.6-xfs8/fs/xfs/quota/xfs_dquot.c	2008-04-22 11:34:01.000000000 +0200
+++ linux-2.6-xfs9/fs/xfs/quota/xfs_dquot.c	2008-04-22 15:12:08.000000000 +0200
@@ -640,7 +640,11 @@ xfs_qm_dqtobp(
  * and release the buffer immediately.
  *
  */
-/* ARGSUSED */
+#ifndef DEBUG
+/* "id" is used only for debugging */
+#define xfs_qm_dqread(tpp, id, dqp, flags) \
+	xfs_qm_dqread(tpp, dqp, flags)
+#endif
 STATIC int
 xfs_qm_dqread(
 	xfs_trans_t	**tpp,
diff -urpN linux-2.6-xfs8/fs/xfs/quota/xfs_qm.c linux-2.6-xfs9/fs/xfs/quota/xfs_qm.c
--- linux-2.6-xfs8/fs/xfs/quota/xfs_qm.c	2008-04-22 11:34:31.000000000 +0200
+++ linux-2.6-xfs9/fs/xfs/quota/xfs_qm.c	2008-04-22 15:12:54.000000000 +0200
@@ -65,6 +65,8 @@ kmem_zone_t	*qm_dqtrxzone;
 
 static cred_t	xfs_zerocr;
 
+/* "str" and "n" are unused */
+#define xfs_qm_list_init(list, str, n) xfs_qm_list_init(list)
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
 
@@ -210,10 +212,10 @@ xfs_qm_destroy(
  * structures are pretty independent, but it helps the XQM keep a
  * global view of what's going on.
  */
-/* ARGSUSED */
 STATIC int
 xfs_qm_hold_quotafs_ref(
-	struct xfs_mount *mp)
+	void
+	/*struct xfs_mount *mp*/)
 {
 	/*
 	 * Need to lock the xfs_Gqm structure for things like this. For example,
@@ -243,7 +245,8 @@ xfs_qm_hold_quotafs_ref(
 /* ARGSUSED */
 STATIC void
 xfs_qm_rele_quotafs_ref(
-	struct xfs_mount *mp)
+	void
+	/*struct xfs_mount *mp*/)
 {
 	xfs_dquot_t	*dqp, *nextdqp;
 
@@ -1122,7 +1125,7 @@ xfs_qm_init_quotainfo(
 	/*
 	 * Tell XQM that we exist as soon as possible.
 	 */
-	if ((error = xfs_qm_hold_quotafs_ref(mp))) {
+	if ((error = xfs_qm_hold_quotafs_ref(/* mp */))) {
 		return error;
 	}
 
@@ -1233,7 +1236,7 @@ xfs_qm_destroy_quotainfo(
 	 * when the XQM structure should be freed. We cannot assume
 	 * that xfs_Gqm is non-null after this point.
 	 */
-	xfs_qm_rele_quotafs_ref(mp);
+	xfs_qm_rele_quotafs_ref(/* mp */);
 
 	spinlock_destroy(&qi->qi_pinlock);
 	xfs_qm_list_destroy(&qi->qi_dqlist);

--Boundary-00=_8qeDIUYBL82VY1V--
