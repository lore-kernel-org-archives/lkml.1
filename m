Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYAaApi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYAaApi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbYAaApR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:45:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28427 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbYAaApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:45:15 -0500
Date: Wed, 30 Jan 2008 16:43:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 2/2] kernel-doc: warn on badly formatted short description
Message-Id: <20080130164323.f773d5b4.randy.dunlap@oracle.com>
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

Make kernel-doc warn when a function/struct/union/typedef does not contain
a properly formatted short description, such as:
 * scsi_devinfo: set up the dynamic device list
or
 * scsi_devinfo -

This warning is only generated when verbose (-v) mode is used.

Also explain the -v command line option in the -h output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.24-git8.orig/scripts/kernel-doc
+++ linux-2.6.24-git8/scripts/kernel-doc
@@ -218,6 +218,7 @@ sub usage {
     print "         [ -function funcname [ -function funcname ...] ]\n";
     print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
     print "         c source file(s) > outputfile\n";
+    print "         -v : verbose output, more warnings & other info listed\n";
     exit 1;
 }
 
@@ -1881,6 +1882,13 @@ sub process_file($) {
 		} else {
 		    $declaration_purpose = "";
 		}
+
+		if (($declaration_purpose eq "") && $verbose) {
+			print STDERR "Warning(${file}:$.): missing initial short description on line:\n";
+			print STDERR $_;
+			++$warnings;
+		}
+
 		if ($identifier =~ m/^struct/) {
 		    $decl_type = 'struct';
 		} elsif ($identifier =~ m/^union/) {
