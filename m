Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYHQWt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYHQWt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYHQWtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:49:52 -0400
Received: from xenotime.net ([66.160.160.81]:48130 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751758AbYHQWtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:49:51 -0400
Date: Sun, 17 Aug 2008 15:50:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: allow space in macro #define
Message-Id: <20080817155011.83ed22ac.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

--- linux-2.6.27-rc3-git4.orig/scripts/kernel-doc
+++ linux-2.6.27-rc3-git4/scripts/kernel-doc
@@ -1644,7 +1644,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
-    $prototype =~ s/^#define\s+//; #ak added
+    $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
@@ -1760,13 +1760,13 @@ sub process_state3_function($$) {
 
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


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
