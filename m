Return-Path: <linux-kernel-owner+w=401wt.eu-S1161113AbXDJXoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113AbXDJXoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161114AbXDJXoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:44:37 -0400
Received: from smtp106.plus.mail.re2.yahoo.com ([206.190.53.31]:42140 "HELO
	smtp106.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161113AbXDJXog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:44:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=wT6Xpost6VtvxTlQc8sOsqBcTSGoCxy6CtJLQlZt1viNpGflhINx5rmxETruTVwYt27pn5CgWwuoAbaebb38AnToQUjNUpbL9Oj+1fiuA0iig+I2W5aJVUwHCqTj35Qp/c0tbLEdOR/MTtJRCoctJpNiVyobiCbWfuO1mIT/6W8=  ;
X-YMail-OSG: LIiTg4kVM1nvi6E3wu2wVglHiJJpTQKSg7Wcr.cZ7MgyQz6.SqCpZobd8Orgit_T5juvz79olA--
Date: Wed, 11 Apr 2007 01:44:22 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com
Subject: [PATCH] [KERNEL-DOC] generate main index page when building 'htmldocs'
Message-ID: <20070410234422.GA30554@zmei.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch for kernel-doc that enables the generation of a global, TOC-like index.html 
page after building 'htmldocs'

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>


Index: 21-rc6/Documentation/DocBook/Makefile
===================================================================
--- 21-rc6.orig/Documentation/DocBook/Makefile	2007-04-11 00:02:02.000000000 +0200
+++ 21-rc6/Documentation/DocBook/Makefile	2007-04-11 01:00:21.000000000 +0200
@@ -44,6 +44,7 @@
 
 HTML := $(patsubst %.xml, %.html, $(BOOKS))
 htmldocs: $(HTML)
+	$(call build_main_index)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
@@ -133,10 +134,17 @@
 %.pdf : %.xml
 	$(call cmd,db2pdf)
 
+
+main_idx = Documentation/DocBook/index.html
+build_main_index = rm -rf $(main_idx) && \
+		   echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
+		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
+		   cat $(HTML) >> $(main_idx)
+
 quiet_cmd_db2html = HTML   $@
       cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
 		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
-         Goto $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
+        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
 
 %.html:	%.xml
 	@(which xmlto > /dev/null 2>&1) || \
