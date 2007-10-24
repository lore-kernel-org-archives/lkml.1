Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbXJXWOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbXJXWOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbXJXWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:14:00 -0400
Received: from xenotime.net ([66.160.160.81]:45171 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754365AbXJXWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:13:57 -0400
Date: Wed, 24 Oct 2007 15:08:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes@sipsolutions.net>,
       sam@ravnborg.org
Subject: [PATCH 5/6] kernel-doc: use no-doc option
Message-ID: <11932637282758@xenotime.net>
In-Reply-To: <11932637282902@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

When asked by a template to include all functions from a file,
it will also include DOC: sections wreaking havoc in the generated
docbook file. This patch makes it use the new -no-doc-sections
flag for kernel-doc to avoid this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/basic/docproc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.23-git19.orig/scripts/basic/docproc.c
+++ linux-2.6.23-git19/scripts/basic/docproc.c
@@ -65,6 +65,7 @@ FILELINE * entity_system;
 #define DOCBOOK       "-docbook"
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
+#define NODOCSECTIONS "-no-doc-sections"
 
 char *srctree;
 
@@ -231,13 +232,14 @@ void docfunctions(char * filename, char 
 
 	for (i=0; i <= symfilecnt; i++)
 		symcnt += symfilelist[i].symbolcnt;
-	vec = malloc((2 + 2 * symcnt + 2) * sizeof(char*));
+	vec = malloc((2 + 2 * symcnt + 3) * sizeof(char*));
 	if (vec == NULL) {
 		perror("docproc: ");
 		exit(1);
 	}
 	vec[idx++] = KERNELDOC;
 	vec[idx++] = DOCBOOK;
+	vec[idx++] = NODOCSECTIONS;
 	for (i=0; i < symfilecnt; i++) {
 		struct symfile * sym = &symfilelist[i];
 		for (j=0; j < sym->symbolcnt; j++) {


-- 

