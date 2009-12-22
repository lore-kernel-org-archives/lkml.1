Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZLVRSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZLVRSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZLVRSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:18:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZLVRSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:18:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Date: Tue, 22 Dec 2009 17:17:41 +0000
Message-ID: <20091222171741.11854.71709.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091222171725.11854.10647.stgit@warthog.procyon.org.uk>
References: <20091222171725.11854.10647.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

Commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes ELF-FDPIC to break
during building, so this patch fixes it together with a correction for the
printk format.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2917ab1..384a19f 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1807,11 +1807,11 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	ELF_CORE_WRITE_EXTRA_DATA;
 #endif
 
-	if (file->f_pos != offset) {
+	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
-		printk(KERN_WARNING
-		       "elf_core_dump: file->f_pos (%lld) != offset (%lld)\n",
-		       file->f_pos, offset);
+		printk(KERN_WARNING "elf_fdpic_core_dump:"
+		       " cprm->file->f_pos (%lld) != offset (%lld)\n",
+		       cprm->file->f_pos, offset);
 	}
 
 end_coredump:

