Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112Ab0A0ACm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0A0ACm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150Ab0A0ACc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:02:32 -0500
Received: from kroah.org ([198.145.64.141]:35170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0AZXnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.883903788@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [23/98] V4L/DVB (13680b): DocBook/media: create links for included sources
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 5bf583473813530c1bf82051a35fac8d5045f4f7 upstream.

If docs are being built in a separate directory, xmlto and xsltproc
can't find included sources.  Make links back to the source directory.

I would much prefer to have xmlto and xsltproc look in the source
directory for included entities but couldn't see how to do that.  This
needs to be solved in some way for 2.6.32, even if this patch isn't the
right way to do it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/DocBook/Makefile |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

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


