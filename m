Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYGUDE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYGUDE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbYGUDD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:03:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:33927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYGUDDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:03:55 -0400
Message-Id: <20080721025912.739333284@suse.de>
User-Agent: quilt/0.46_cvs20080326-18
Date: Mon, 21 Jul 2008 04:28:24 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [genksyms patch 1/4] parser: fix the __attribute__ rule
References: <20080721022823.896799736@suse.de>
Content-Disposition: inline; filename=patches.suse/genksyms-syntax.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc __attribute__ definitions may occur repeatedly, e.g.,

	static int foo __attribute__((__used__))
		       __attribute__((aligned (16)));

The genksyms parser does not understand this, and generates a syntax error.
Fix this case.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 scripts/genksyms/parse.y |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/scripts/genksyms/parse.y
===================================================================
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -446,7 +446,7 @@ member_bitfield_declarator:
 
 attribute_opt:
 	/* empty */					{ $$ = NULL; }
-	| ATTRIBUTE_PHRASE
+	| attribute_opt ATTRIBUTE_PHRASE
 	;
 
 asm_definition:


