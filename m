Return-Path: <linux-kernel-owner+w=401wt.eu-S1161664AbXEAKOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161664AbXEAKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161668AbXEAKOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:14:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161664AbXEAKO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:14:29 -0400
Subject: [GFS2] use log_error before LM_OUT_ERROR [14/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:09:56 +0100
Message-Id: <1178014196.5462.155.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9af8a788ade3435b53667873774b5366cf73f58 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 28 Mar 2007 11:08:04 -0500
Subject: [PATCH] [GFS2] use log_error before LM_OUT_ERROR

We always want to see the details of the error returned to gfs, but
log_debug is often turned off, so use log_error (printk).

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index f9c8bda..c305255 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -266,7 +266,7 @@ unsigned int gdlm_do_lock(struct gdlm_lock *lp)
 	}
 
 	if (error) {
-		log_debug("%s: gdlm_lock %x,%llx err=%d cur=%d req=%d lkf=%x "
+		log_error("%s: gdlm_lock %x,%llx err=%d cur=%d req=%d lkf=%x "
 			  "flags=%lx", ls->fsname, lp->lockname.ln_type,
 			  (unsigned long long)lp->lockname.ln_number, error,
 			  lp->cur, lp->req, lp->lkf, lp->flags);
@@ -294,7 +294,7 @@ static unsigned int gdlm_do_unlock(struct gdlm_lock *lp)
 	error = dlm_unlock(ls->dlm_lockspace, lp->lksb.sb_lkid, lkf, NULL, lp);
 
 	if (error) {
-		log_debug("%s: gdlm_unlock %x,%llx err=%d cur=%d req=%d lkf=%x "
+		log_error("%s: gdlm_unlock %x,%llx err=%d cur=%d req=%d lkf=%x "
 			  "flags=%lx", ls->fsname, lp->lockname.ln_type,
 			  (unsigned long long)lp->lockname.ln_number, error,
 			  lp->cur, lp->req, lp->lkf, lp->flags);
-- 
1.5.1.2



