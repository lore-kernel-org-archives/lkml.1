Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZHRQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZHRQl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZHRQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:41:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759325AbZHRQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:41:24 -0400
Date: Tue, 18 Aug 2009 12:41:25 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH perf] make 'make html' work
Message-ID: <20090818164125.GM25206@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

pushd tools/perf/Documentation
make html
popd

is failing for me... 

    ASCIIDOC perf-annotate.html                                                 
ERROR: unsafe: include file: /etc/asciidoc/./stylesheets/xhtml11.css
ERROR: unsafe: include file:
/etc/asciidoc/./stylesheets/xhtml11-manpage.css
ERROR: unsafe: include file:
/etc/asciidoc/./stylesheets/xhtml11-quirks.css
make: *** [perf-annotate.html] Error 1

Apparently asciidoc "unsafe" is the default mode of operation
in practice.

https://bugzilla.redhat.com/show_bug.cgi?id=506953

Works tidily now.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 5457192..bdd3b7e 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -35,7 +35,7 @@ man7dir=$(mandir)/man7
 # DESTDIR=
 
 ASCIIDOC=asciidoc
-ASCIIDOC_EXTRA =
+ASCIIDOC_EXTRA = --unsafe
 MANPAGE_XSL = manpage-normal.xsl
 XMLTO_EXTRA =
 INSTALL?=install
