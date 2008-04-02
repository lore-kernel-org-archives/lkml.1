Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYDBWv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYDBWv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbYDBWvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:51:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60254 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbYDBWvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:51:50 -0400
Date: Wed, 2 Apr 2008 15:46:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: detect trailing kernel-doc line trash
Message-Id: <20080402154634.9466ea6a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

Print a warning when a kernel-doc comment block ends with text on the
same line as the ending comment characters, e.g.:

 * this text is lost. */

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    5 +++++
 1 file changed, 5 insertions(+)

--- lin2625-rc8-kdoc.orig/scripts/kernel-doc
+++ lin2625-rc8-kdoc/scripts/kernel-doc
@@ -1950,6 +1950,11 @@ sub process_file($) {
 		    $section = $section_default;
 		    $contents = "";
 		}
+		# look for doc_com + <text> + doc_end:
+		if ($_ =~ m'\s*\*\s*[a-zA-Z_0-9:\.]+\*/') {
+		    print STDERR "Warning(${file}:$.): suspicious ending line: $_";
+		    ++$warnings;
+		}
 
 		$prototype = "";
 		$state = 3;
