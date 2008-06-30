Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbYF3VlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbYF3VlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932921AbYF3Veu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48256 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbYF3Vee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 16/24] kernel-doc: handle/strip __init
Date: Mon, 30 Jun 2008 23:35:10 +0200
Message-Id: <1214861718-32626-16-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Handle __init in functions with kernel-doc notation by stripping the
__init away from the output doc.  This is already being done for
"__devinit".  This patch fixes these kernel-doc error/aborts:

Error(linux-next-20080619//drivers/usb/gadget/config.c:132): cannot understand prototype: 'struct usb_descriptor_header **__init usb_copy_descriptors(struct usb_descriptor_header **src) '
Error(linux-next-20080619//drivers/usb/gadget/config.c:182): cannot understand prototype: 'struct usb_endpoint_descriptor *__init usb_find_endpoint( 	struct usb_descriptor_header **src, 	struct usb_descriptor_header **copy, 	struct usb_endpoint_descriptor *match ) '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kernel-doc |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 88e3934..d8f77e2 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1643,6 +1643,7 @@ sub dump_function($$) {
     $prototype =~ s/^__always_inline +//;
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
+    $prototype =~ s/__init +//;
     $prototype =~ s/^#define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
-- 
1.5.6.1.93.gef98

