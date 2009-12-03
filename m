Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZLCWuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZLCWuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZLCWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:50:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36724 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZLCWug convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:50:36 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Dec 2009 22:50:35 +0000
Message-ID: <1259880635.4532.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH RESEND 1/2] DocBook/media: copy images after building HTML
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rule for %.html removes the output directory, so there is no point
in copying images before building HTML.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org
---
 Documentation/DocBook/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index ab8300f..22bbf7e 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -32,7 +32,7 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs media
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
 xmldocs: $(BOOKS)
@@ -45,15 +45,15 @@ PDF := $(patsubst %.xml, %.pdf, $(BOOKS))
 pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
-htmldocs: media $(HTML)
+htmldocs: $(HTML)
 	$(call build_main_index)
+	$(call build_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
 
-media:
-	mkdir -p $(srctree)/Documentation/DocBook/media/
-	cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(srctree)/Documentation/DocBook/media/
+build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
+	       cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(objtree)/Documentation/DocBook/media/
 
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
-- 
1.6.5.2




