Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbXBKGvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbXBKGvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXBKGvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:51:51 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58839 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbXBKGvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:51:50 -0500
Date: Sat, 10 Feb 2007 22:47:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fix fatal kernel-doc error
Message-Id: <20070210224733.a98abc9a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Teach kernel-doc to handle functions that look like the new
pcim_iomap_table().  Fixes this fatal error in scripts/kernel-doc:

  DOCPROC Documentation/DocBook/kernel-api.xml
Error(/tester/linsrc/linux-2.6.20-git6//drivers/pci/pci.c:1351): cannot understand prototype: 'void __iomem * const * pcim_iomap_table(struct pci_dev *pdev) '
make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1
make: *** [htmldocs] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20-git6.orig/scripts/kernel-doc
+++ linux-2.6.20-git6/scripts/kernel-doc
@@ -1570,7 +1570,8 @@ sub dump_function($$) {
 	$prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
+	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s*\*\s*\w+\s*\*\s*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
 	$return_type = $1;
 	$declaration_name = $2;
 	my $args = $3;
