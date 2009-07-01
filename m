Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZGAFHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZGAFHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZGAFHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:07:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33405 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZGAFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:07:08 -0400
Date: Wed, 1 Jul 2009 01:06:26 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
Subject: [Patch 1/3] elf: fix one check-after-use
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Check before use it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>

---
Index: linux-2.6/fs/binfmt_elf.c
===================================================================
--- linux-2.6.orig/fs/binfmt_elf.c
+++ linux-2.6/fs/binfmt_elf.c
@@ -1522,11 +1522,11 @@ static int fill_note_info(struct elfhdr 
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
-
 	if (psinfo == NULL)
 		return 0;
 
+	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
+
 	/*
 	 * Figure out how many notes we're going to need for each thread.
 	 */
