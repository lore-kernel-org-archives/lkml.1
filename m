Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZJFNeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZJFNeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZJFNeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:34:14 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:40135 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbZJFNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:34:13 -0400
Date: Tue, 6 Oct 2009 15:33:35 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: Allow sysfs_move_dir(..., NULL) again.
Message-ID: <20091006153335.15d02d12@gondolin>
In-Reply-To: <1254819129.23533.27.camel@pcarmody-desktop>
References: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
	<20091005183753.4d77afcb@gondolin>
	<1254819129.23533.27.camel@pcarmody-desktop>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As device_move() and kobject_move() both handle a NULL destination,
sysfs_move_dir() should do this as well (again) and fall back to
sysfs_root in that case.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 fs/sysfs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -894,7 +894,8 @@ int sysfs_move_dir(struct kobject *kobj,
 
 	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
+	new_parent_sd = (new_parent_kobj && new_parent_kobj->sd) ?
+		new_parent_kobj->sd : &sysfs_root;
 
 	error = 0;
 	if (sd->s_parent == new_parent_sd)
