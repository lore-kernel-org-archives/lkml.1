Return-Path: <linux-kernel-owner+w=401wt.eu-S933319AbXGaSHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbXGaSHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761031AbXGaSG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:06:56 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3483 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbXGaSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:06:55 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 35] fs/reiser4/plugin/inode_ops_rename.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:06:54 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312006.54765.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/plugin/inode_ops_rename.c | 28474 -> 28344 (-130 bytes)
 fs/reiser4/plugin/inode_ops_rename.o | 142600 -> 142476 (-124 bytes)

 fs/reiser4/plugin/inode_ops_rename.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/plugin/inode_ops_rename.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/plugin/inode_ops_rename.c	2007-07-31 15:02:58.000000000 +0200
@@ -392,16 +392,14 @@ int reiser4_rename_common(struct inode *
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);

-	old_entry = kmalloc(3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
+	old_entry = kzalloc(3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
 			    sizeof(*dotdot_name) + sizeof(*dataonstack),
 			    reiser4_ctx_gfp_mask_get());
-	if (old_entry == NULL) {
+	if (!old_entry) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 		return RETERR(-ENOMEM);
 	}
-	memset(old_entry, 0, 3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
-	       sizeof(*dotdot_name) + sizeof(*dataonstack));

 	new_entry = old_entry + 1;
 	dotdot_entry = old_entry + 2;
