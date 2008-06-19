Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYFSXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYFSXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYFSXJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:09:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16118 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYFSXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:09:47 -0400
Date: Thu, 19 Jun 2008 16:03:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>,
       dbrownell@users.sourceforge.net
Subject: [PATCH] kernel-doc: handle/strip __init
Message-Id: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

cc: David Brownell <dbrownell@users.sourceforge.net>

Handle __init in functions with kernel-doc notation by stripping the
__init away from the output doc.  This is already being done for
"__devinit".  This patch fixes these kernel-doc error/aborts:

Error(linux-next-20080619//drivers/usb/gadget/config.c:132): cannot understand prototype: 'struct usb_descriptor_header **__init usb_copy_descriptors(struct usb_descriptor_header **src) '
Error(linux-next-20080619//drivers/usb/gadget/config.c:182): cannot understand prototype: 'struct usb_endpoint_descriptor *__init usb_find_endpoint( 	struct usb_descriptor_header **src, 	struct usb_descriptor_header **copy, 	struct usb_endpoint_descriptor *match ) '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20080619.orig/scripts/kernel-doc
+++ linux-next-20080619/scripts/kernel-doc
@@ -1643,6 +1643,7 @@ sub dump_function($$) {
     $prototype =~ s/^__always_inline +//;
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
+    $prototype =~ s/__init +//;
     $prototype =~ s/^#define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
