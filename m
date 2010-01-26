Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710Ab0A0ADJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0A0ADJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691Ab0A0ACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:02:51 -0500
Received: from kroah.org ([198.145.64.141]:35169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0AZXnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.767452258@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [22/98] V4L/DVB (13680a): DocBook/media: copy images after building HTML
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 49b14650ba5bf80234cb1984fd8396aff03430ce upstream.

The rule for %.html removes the output directory, so there is no point
in copying images before building HTML.

Documentation/DocBook/Makefile |   10 +++++-----

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/DocBook/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -32,7 +32,7 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs media
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
 xmldocs: $(BOOKS)
@@ -45,15 +45,15 @@ PDF := $(patsubst %.xml, %.pdf, $(BOOKS)
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


