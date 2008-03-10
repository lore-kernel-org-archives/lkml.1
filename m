Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYCJRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYCJRmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCJRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:42:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14751 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYCJRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:42:05 -0400
Date: Mon, 10 Mar 2008 10:41:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH v2 resend] kernel-doc: set verbose mode via environment
Message-Id: <20080310104146.d41117d2.randy.dunlap@oracle.com>
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

Honor the environment variable "KBUILD_VERBOSE=1" (as set by
make V=1) to enable verbose mode in scripts/kernel-doc.  Useful for
getting more info and warnings from kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2625-rc3-kdoc.orig/scripts/kernel-doc
+++ linux-2625-rc3-kdoc/scripts/kernel-doc
@@ -247,6 +247,10 @@ my ($function, %function_table,%paramete
 my ($type,$declaration_name,$return_type);
 my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
 
+if (defined($ENV{'KBUILD_VERBOSE'})) {
+	$verbose = "$ENV{'KBUILD_VERBOSE'}";
+}
+
 # Generated docbook code is inserted in a template at a point where
 # docbook v3.1 requires a non-zero sequence of RefEntry's; see:
 # http://www.oasis-open.org/docbook/documentation/reference/html/refentry.html

--
