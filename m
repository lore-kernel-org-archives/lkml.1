Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbYBSWNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbYBSWNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYBSWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:41 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54060 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbYBSWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:40 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] alpha: handle kcalloc failure
Date: Tue, 19 Feb 2008 23:13:34 +0100
Message-Id: <1203459219-14719-2-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-1-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* arch/alpha/kernel/module.c (module_frob_arch_sections): Handle kcalloc failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/alpha/kernel/module.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index 026ba9a..ebc3c89 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -120,6 +120,12 @@ module_frob_arch_sections(Elf64_Ehdr *hdr, Elf64_Shdr *sechdrs,

 	nsyms = symtab->sh_size / sizeof(Elf64_Sym);
 	chains = kcalloc(nsyms, sizeof(struct got_entry), GFP_KERNEL);
+	if (!chains) {
+		printk(KERN_ERR
+		       "module %s: no memory for symbol chain buffer\n",
+		       me->name);
+		return -ENOMEM;
+	}

 	got->sh_size = 0;
 	got->sh_addralign = 8;
-- 
1.5.4.2.134.g82883

