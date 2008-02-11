Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbYBKRrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbYBKRrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYBKRq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:46:58 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56232 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYBKRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:46:57 -0500
Message-ID: <47B08A0B.4020604@tiscali.nl>
Date: Mon, 11 Feb 2008 18:46:51 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: sfrench@samba.org
CC: linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][fs/cifs/cifsfs.c] Make use of cifs_xquota_get
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions cifs_xquota_set and cifs_xquota_get at respectively
fs/cifs/cifsfs.c:367 and 392 are entirely similar - except for
whitespace

struct quotactl_ops contains function pointers .set_xquota and
.get_xquota that both get the address of cifs_xquota_set.
cifs_xquota_get isn't called anywhere else in the kernel.

The patch below makes use of the function cifs_xquota_get, As
an alternative the entire function cifs_xquota_get could be 
removed.
---
Make use of cifs_xquota_get

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fcc4342..339b829 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -461,7 +461,7 @@ int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
 
 static struct quotactl_ops cifs_quotactl_ops = {
 	.set_xquota	= cifs_xquota_set,
-	.get_xquota	= cifs_xquota_set,
+	.get_xquota	= cifs_xquota_get,
 	.set_xstate	= cifs_xstate_set,
 	.get_xstate	= cifs_xstate_get,
 };
