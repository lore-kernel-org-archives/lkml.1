Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXJXWOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXJXWOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXJXWN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:13:58 -0400
Received: from xenotime.net ([66.160.160.81]:58840 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753135AbXJXWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:13:57 -0400
Date: Wed, 24 Oct 2007 15:08:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes@sipsolutions.net>,
       sam@ravnborg.org
Subject: [PATCH 1/6] kernel-doc: fix xml output mode
Message-ID: <11932637283188@xenotime.net>
In-Reply-To: <11932637282902@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

After Randy's patch fixing the HTML output in DOC: sections
(6b5b55f6c404fa730a09a8254eb19f5a038afcc2) the same bug remained in XML
mode, this fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-git19.orig/scripts/kernel-doc
+++ linux-2.6.23-git19/scripts/kernel-doc
@@ -182,10 +182,10 @@ my $blankline_html = $local_lt . "p" . $
 my %highlights_xml = ( "([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>",
 			$type_constant, "<constant>\$1</constant>",
 			$type_func, "<function>\$1</function>",
-			$type_struct, "<structname>\$1</structname>",
+			$type_struct_xml, "<structname>\$1</structname>",
 			$type_env, "<envar>\$1</envar>",
 			$type_param, "<parameter>\$1</parameter>" );
-my $blankline_xml = "</para><para>\n";
+my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $local_gt . "\n";
 
 # gnome, docbook format
 my %highlights_gnome = ( $type_constant, "<replaceable class=\"option\">\$1</replaceable>",
@@ -394,7 +394,7 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
-    if ($output_mode eq "html") {
+    if ($output_mode eq "html" || $output_mode eq "xml") {
 	$contents = local_unescape($contents);
 	# convert data read & converted thru xml_escape() into &xyz; format:
 	$contents =~ s/\\\\\\/&/g;


-- 

