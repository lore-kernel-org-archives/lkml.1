Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXKBPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXKBPq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbXKBPoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:44:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53867 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760330AbXKBPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:52 -0400
Date: Fri, 2 Nov 2007 16:44:30 +0100
From: Adrian Bunk <bunk@kernel.org>
To: dipankar@in.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make srcu_readers_active() static
Message-ID: <20071102154430.GP30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global srcu_readers_active() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/srcu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

42cffc77c0fc5bde75564dd7f9c9dc7e5c5364fd 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 3507cab..b0aeeaf 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -74,7 +74,7 @@ static int srcu_readers_active_idx(struct srcu_struct *sp, int idx)
  * severe errors when invoked on an active srcu_struct.  That said, it
  * can be useful as an error check at cleanup time.
  */
-int srcu_readers_active(struct srcu_struct *sp)
+static int srcu_readers_active(struct srcu_struct *sp)
 {
 	return srcu_readers_active_idx(sp, 0) + srcu_readers_active_idx(sp, 1);
 }
@@ -255,4 +255,3 @@ EXPORT_SYMBOL_GPL(srcu_read_lock);
 EXPORT_SYMBOL_GPL(srcu_read_unlock);
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
-EXPORT_SYMBOL_GPL(srcu_readers_active);

