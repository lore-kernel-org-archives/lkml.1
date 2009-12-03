Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZLCWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZLCWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZLCWvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:51:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36730 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbZLCWvI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:51:08 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Dec 2009 22:51:09 +0000
Message-ID: <1259880669.4532.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH RESEND 2/2] DocBook/media: create links for included sources
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If docs are being built in a separate directory, xmlto and xsltproc
can't find included sources.  Make links back to the source directory.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org
---
I would much prefer to have xmlto and xsltproc look in the source
directory for included entities but couldn't see how to do that.  This
needs to be solved in some way for 2.6.32, even if this patch isn't the
right way to do it.

Ben.

 Documentation/DocBook/Makefile |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 22bbf7e..50075df 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -32,10 +32,10 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS)
+xmldocs: $(BOOKS) xmldoclinks
 sgmldocs: xmldocs
 
 PS := $(patsubst %.xml, %.ps, $(BOOKS))
@@ -55,6 +55,15 @@ mandocs: $(MAN)
 build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
 	       cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(objtree)/Documentation/DocBook/media/
 
+xmldoclinks:
+ifneq ($(objtree),$(srctree))
+	for dep in dvb media-entities.tmpl media-indices.tmpl v4l; do \
+		rm -f $(objtree)/Documentation/DocBook/$$dep \
+		&& ln -s $(srctree)/Documentation/DocBook/$$dep $(objtree)/Documentation/DocBook/ \
+		|| exit; \
+	done
+endif
+
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
 	install Documentation/DocBook/man/*.9.gz /usr/local/man/man9/
-- 
1.6.5.2



