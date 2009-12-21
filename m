Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbZLUCEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbZLUCEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932125AbZLUCEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:04:38 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52341 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbZLUCEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:04:36 -0500
Date: Mon, 21 Dec 2009 11:04:31 +0900 (JST)
Message-Id: <20091221.110431.189715673.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: mhiramat@redhat.com
Subject: [PATCH] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes build
break, so this patch fixes it together with the correction for printk
format.

Thanks.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf_fdpic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index c25256a..b0f2732 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1798,11 +1798,11 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	ELF_CORE_WRITE_EXTRA_DATA;
 #endif
 
-	if (file->f_pos != offset) {
+	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
 		printk(KERN_WARNING
-		       "elf_core_dump: file->f_pos (%lld) != offset (%lld)\n",
-		       file->f_pos, offset);
+		       "elf_fdpic_core_dump: cprm->file->f_pos (%lld) != offset (%lld)\n",
+		       cprm->file->f_pos, offset);
 	}
 
 end_coredump:
-- 
1.6.5.1

