Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbXEUQX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbXEUQX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbXEUQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:22:59 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:57335 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbXEUQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:22:58 -0400
Date: Tue, 22 May 2007 01:23:14 +0900 (JST)
Message-Id: <20070522.012314.122830458.anemo@mba.ocn.ne.jp>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: [PATCH] kbuild: fix and improve MIPS REL handling 
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add R_MIPS_32 relocation case.
And there is no need to do sign-extention on calculation of addend.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This is a patch against kbuild-tree.

--- linux-kbuild/scripts/mod/modpost.c	2007-05-22 01:14:45.000000000 +0900
+++ linux/scripts/mod/modpost.c	2007-05-22 01:11:03.000000000 +0900
@@ -967,11 +967,14 @@ static int addend_mips_rel(struct elf_in
 	inst = TO_NATIVE(*location);
 	switch (r_typ) {
 	case R_MIPS_LO16:
-		r->r_addend = ((inst & 0xffff) ^ 0x8000) - 0x8000;
+		r->r_addend = inst & 0xffff;
 		break;
 	case R_MIPS_26:
 		r->r_addend = (inst & 0x03ffffff) << 2;
 		break;
+	case R_MIPS_32:
+		r->r_addend = inst;
+		break;
 	}
 	return 0;
 }
