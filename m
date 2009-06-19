Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZFSHHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZFSHHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZFSHHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:07:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZFSHHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:07:36 -0400
Date: Fri, 19 Jun 2009 03:06:54 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org, sam@ravnborg.org,
       Amerigo Wang <amwang@redhat.com>, jirislaby@gmail.com
Message-Id: <20090619070909.6422.28484.sendpatchset@localhost.localdomain>
Subject: [Patch] kbuild: fix a build error during make htmldocs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following build error when do 'make htmldocs':

 DOCPROC Documentation/DocBook/debugobjects.xml
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam <sam@ravnborg.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index 4c9523e..99ca7a6 100644
--- a/scripts/basic/docproc.c
+++ b/scripts/basic/docproc.c
@@ -385,7 +385,7 @@ int main(int argc, char *argv[])
 	if (!srctree)
 		srctree = getcwd(NULL, 0);
 	kernsrctree = getenv("KBUILD_SRC");
-	if (!kernsrctree)
+	if (!kernsrctree || !*kernsrctree)
 		kernsrctree = srctree;
 	if (argc != 3) {
 		usage();
