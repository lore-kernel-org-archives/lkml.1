Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYJZAHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYJZAHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYJZAHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:07:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64846 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYJZAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:07:08 -0400
Date: Sat, 25 Oct 2008 17:06:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel-doc: allow more whitespace in macros
Message-Id: <20081025170643.9bc33549.randy.dunlap@oracle.com>
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

Allow macros that are annotated with kernel-doc to contain whitespace
between the '#' and "define".  It's valid and being used, so allow it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.28-rc1-git1.orig/scripts/kernel-doc
+++ linux-2.6.28-rc1-git1/scripts/kernel-doc
@@ -1648,7 +1648,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
-    $prototype =~ s/^#define\s+//; #ak added
+    $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
@@ -1764,13 +1764,13 @@ sub process_state3_function($$) {
 
     $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
 
-    if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#define/)) {
+    if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#\s*define/)) {
 	# do nothing
     }
     elsif ($x =~ /([^\{]*)/) {
 	$prototype .= $1;
     }
-    if (($x =~ /\{/) || ($x =~ /\#define/) || ($x =~ /;/)) {
+    if (($x =~ /\{/) || ($x =~ /\#\s*define/) || ($x =~ /;/)) {
 	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
