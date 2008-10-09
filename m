Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbYJIX5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbYJIX5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYJIXzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:55:01 -0400
Received: from xenotime.net ([66.160.160.81]:33511 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753054AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] docs: fix docbook cmd output alignment
Message-ID: <12235963553648@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Ulrich Niedermann <hun@n-dimensional.de>

The total width of the command name plus spaces should be
8 characters, but were 7 and 9, respectively. With 8 chars,
all commands are now lining up nicely.

The mandocs, psdocs, xmldocs commands are OK.

Before:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML   Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF      Documentation/DocBook/wanbook.pdf

After:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML    Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF     Documentation/DocBook/wanbook.pdf

Signed-off-by: Hans Ulrich Niedermann <hun@n-dimensional.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/DocBook/Makefile
+++ linux-2.6.27-rc9-git2/Documentation/DocBook/Makefile
@@ -136,7 +136,7 @@ quiet_cmd_db2ps = PS      $@
 %.ps : %.xml
 	$(call cmd,db2ps)
 
-quiet_cmd_db2pdf = PDF      $@
+quiet_cmd_db2pdf = PDF     $@
       cmd_db2pdf = $(subst TYPE,pdf, $($(PDF_METHOD)template))
 %.pdf : %.xml
 	$(call cmd,db2pdf)
@@ -148,7 +148,7 @@ build_main_index = rm -rf $(main_idx) &&
 		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
 		   cat $(HTML) >> $(main_idx)
 
-quiet_cmd_db2html = HTML   $@
+quiet_cmd_db2html = HTML    $@
       cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
 		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
         $(patsubst %.html,%,$(notdir $@))</a><p>' > $@


-- 

