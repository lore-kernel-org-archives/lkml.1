Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXJ0OT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXJ0OT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbXJ0OTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:19:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57348 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751287AbXJ0OTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:19:36 -0400
Date: Sat, 27 Oct 2007 16:19:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/afs/vlocation.c: fix off-by-one
Message-ID: <20071027141957.GY30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one error spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d88aac5aa6057a8d784934dc5035e9e853b16203 
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 7b4bbe4..849fc31 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -376,19 +376,19 @@ struct afs_vlocation *afs_vlocation_lookup(struct afs_cell *cell,
 					   size_t namesz)
 {
 	struct afs_vlocation *vl;
 	int ret;
 
 	_enter("{%s},{%x},%*.*s,%zu",
 	       cell->name, key_serial(key),
 	       (int) namesz, (int) namesz, name, namesz);
 
-	if (namesz > sizeof(vl->vldb.name)) {
+	if (namesz >= sizeof(vl->vldb.name)) {
 		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	/* see if we have an in-memory copy first */
 	down_write(&cell->vl_sem);
 	spin_lock(&cell->vl_lock);
 	list_for_each_entry(vl, &cell->vl_list, link) {
 		if (vl->vldb.name[namesz] != '\0')

