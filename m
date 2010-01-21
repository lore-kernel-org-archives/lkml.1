Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AUEEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AUEEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277Ab0AUEEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:04:09 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:33529 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0AUEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l6S8Ak/nizXODktjjuthst8Czp36o9weRNAao8sA1ot+aGBbBcNXT+YfxNjFqVrvkk
         BwxG5DlglojfxErw7ZnVdNTGSWh1MysB0G4irWf19FUPJerjiHSBafIndDw8DjIdOIw8
         YcYTV/F5tPnm/ikLIwSFMy4V1lxooo2KztfNE=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs/binfmt_elf.c: fix a do-while statement.
Date: Wed, 20 Jan 2010 23:03:53 -0500
Message-Id: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.243.gff6d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: do-while statement is not a compound statement

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 fs/binfmt_elf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index edd90c4..75d6468 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1404,9 +1404,9 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
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
 
-- 
1.6.6.243.gff6d2

