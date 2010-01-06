Return-Path: <linux-kernel-owner+w=401wt.eu-S932429Ab0AFRYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0AFRYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342Ab0AFRYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:24:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0AFRYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:24:45 -0500
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
Date: Wed, 06 Jan 2010 17:23:33 +0000
Message-ID: <20100106172333.25862.40963.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk>
References: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk>
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

 fs/binfmt_elf_fdpic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index c57d9ce..384a19f 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1809,8 +1809,8 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 
 	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
-		printk(KERN_WARNING
-		       "elf_core_dump: file->f_pos (%lld) != offset (%lld)\n",
+		printk(KERN_WARNING "elf_fdpic_core_dump:"
+		       " cprm->file->f_pos (%lld) != offset (%lld)\n",
 		       cprm->file->f_pos, offset);
 	}
 

