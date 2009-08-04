Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZHDU1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZHDU1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHDU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:27:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42826 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbZHDU1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:27:08 -0400
Date: Tue, 4 Aug 2009 22:27:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/parisc: correct use of SHF_ALLOC
Message-ID: <Pine.LNX.4.64.0908042226231.3737@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SHF_ALLOC is suitable for testing against the sh_flags field, not the
sh_type field.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/parisc/kernel/module.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index ef5caf2..c904817 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -853,7 +853,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 	 * ourselves */
 	for (i = 1; i < hdr->e_shnum; i++) {
 		if(sechdrs[i].sh_type == SHT_SYMTAB
-		   && (sechdrs[i].sh_type & SHF_ALLOC)) {
+		   && (sechdrs[i].sh_flags & SHF_ALLOC)) {
 			int strindex = sechdrs[i].sh_link;
 			/* FIXME: AWFUL HACK
 			 * The cast is to drop the const from
