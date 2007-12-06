Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXLFP1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXLFP1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXLFP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:27:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:43468 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXLFP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cvtchlcFdS20J8Ww9eV3inKHU4kjU0Zuyb8kM4ixfx4tnZjuyg6ga2WVmcUPvB106u606W6ot0O+Z6aAfqx+sDiwePuCbjBBlb0TMo8wn4NqHegGmgBaUve/qbudosQ7co7uleUDRd3Y10ZzyrXfUsIx1O9yXQvfmekZo/0Dn0w=
From: Denis Cheng <crquan@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] fs/afs/cell.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 23:25:13 +0800
Message-Id: <1196954713-5545-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/afs/cell.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 970d38f..b4a09ab 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -20,7 +20,7 @@
 DECLARE_RWSEM(afs_proc_cells_sem);
 LIST_HEAD(afs_proc_cells);
 
-static struct list_head afs_cells = LIST_HEAD_INIT(afs_cells);
+static LIST_HEAD(afs_cells);
 static DEFINE_RWLOCK(afs_cells_lock);
 static DECLARE_RWSEM(afs_cells_sem); /* add/remove serialisation */
 static DECLARE_WAIT_QUEUE_HEAD(afs_cells_freeable_wq);
-- 
1.5.3.4

