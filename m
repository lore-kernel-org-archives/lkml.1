Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZDPXp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZDPXp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZDPXpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:45:13 -0400
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:34418 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755290AbZDPXpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:45:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] fs/binfmt_elf.c: fix sparse warning
Date: Thu, 16 Apr 2009 19:44:15 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9037@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/binfmt_elf.c: fix sparse warning
Thread-Index: Acm+7UB0wlmzUoMuRkGCPCrF9MW8Ow==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 23:45:10.0536 (UTC) FILETIME=[61475080:01C9BEED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in fs/binfmt_elf.c.

  warning: do-while statement is not a compound statement

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 40381df..9273836 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1407,9 +1407,9 @@ static void fill_auxv_note(struct memelfnote
*note, struct mm_struct *mm)
 {
 	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
 	int i = 0;
-	do
+	do {
 		i += 2;
-	while (auxv[i - 2] != AT_NULL);
+	} while (auxv[i - 2] != AT_NULL);
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
  
