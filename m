Return-Path: <linux-kernel-owner+w=401wt.eu-S934492AbXEGSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbXEGSK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934484AbXEGSK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:10:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15156 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934481AbXEGSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:10:56 -0400
Date: Mon, 7 May 2007 11:13:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH] kernel-doc: small kernel-doc optimization
Message-Id: <20070507111311.443719f7.randy.dunlap@oracle.com>
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

From: Borislav Petkov <bbpetkov@yahoo.de>

Get the kernel version string only once from the environment, thus slightly
speeding up kernel-doc.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2621-mm1.orig/scripts/kernel-doc
+++ linux-2621-mm1/scripts/kernel-doc
@@ -337,6 +337,7 @@ sub get_kernel_version() {
     }
     return $version;
 }
+my $kernelversion = get_kernel_version();
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
@@ -610,7 +611,7 @@ sub output_function_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'function'}."</refname>\n";
@@ -687,7 +688,7 @@ sub output_struct_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
@@ -772,7 +773,7 @@ sub output_enum_xml(%) {
     print "<refmeta>\n";
     print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . get_kernel_version() . "</refmiscinfo>\n";
+    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
     print " <refname>enum ".$args{'enum'}."</refname>\n";
