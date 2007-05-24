Return-Path: <linux-kernel-owner+w=401wt.eu-S1763058AbXEXDzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763058AbXEXDzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbXEXDzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:55:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26898 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbXEXDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:55:24 -0400
Date: Wed, 23 May 2007 20:59:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: fix leading dot in man-mode output
Message-Id: <20070523205940.5bc4fdb2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

If a parameter description begins with a '.', this indicates a
"request" for "man" mode output (*roff), so it needs special
handling.

Problem case is in include/asm-i386/atomic.h for function
atomic_add_unless():
 * @u: ...unless v is equal to u.
This parameter description is currently not printed in man mode output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc2-git4.orig/scripts/kernel-doc
+++ linux-2.6.21-rc2-git4/scripts/kernel-doc
@@ -384,8 +384,13 @@ sub output_highlight {
       if ($line eq ""){
 	    print $lineprefix, $blankline;
 	} else {
-            $line =~ s/\\\\\\/\&/g;
-	    print $lineprefix, $line;
+	    $line =~ s/\\\\\\/\&/g;
+	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
+		print "\\{$line";
+	    }
+	    else {
+		print $lineprefix, $line;
+	    }
 	}
 	print "\n";
     }
