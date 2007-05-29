Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXE2T2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXE2T2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXE2T2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:28:38 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58706
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXE2T2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:28:37 -0400
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [patch] tweak make htmldocs (nochunks and better index).
Date: Tue, 29 May 2007 15:28:33 -0400
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705291528.34092.rob@landley.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

A) The "xmtml-nochunks" version of "make htmldocs" is easier to print.

B) Update the generated index.html to use the html <title> as a
   description for each file it links to.

--

--- git/Documentation/DocBook/Makefile	2007-05-23 16:36:56.000000000 -0400
+++ work/Documentation/DocBook/Makefile	2007-05-26 23:11:36.000000000 -0400
@@ -141,9 +141,12 @@
 		   cat $(HTML) >> $(main_idx)
 
 quiet_cmd_db2html = HTML   $@
-      cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
-		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
-        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
+      cmd_db2html = xmlto xhtml-nochunks $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
+		NAME='$(patsubst %.html,%,$(notdir $@))'; \
+		echo -n "<p><a HREF=\"$$NAME/$$NAME.html\">$$NAME</a>" > $@ ; \
+		sed -nre 's@.*<title>(.*)</title>.*@\1@p' \
+			"Documentation/DocBook/$$NAME/$$NAME.html" >> $@ ; \
+		echo '<\p>' >> $@
 
 %.html:	%.xml
 	@(which xmlto > /dev/null 2>&1) || \
