Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYIORDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYIORDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYIORDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:03:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32401 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYIORDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:03:22 -0400
Date: Mon, 15 Sep 2008 10:02:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>,
       Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] kernel-doc: allow structs whose members are all private
Message-Id: <20080915100229.cf32f74e.randy.dunlap@oracle.com>
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

Fix kernel-doc to handle structs whose members are all private;
otherwise invalid XML is generated:

xmlto: input does not validate (status 3)
linux-2.6.27-rc6-git4/Documentation/DocBook/debugobjects.xml:146: element variablelist: validity error : Element variablelist content does not follow the DTD, expecting ((title , titleabbrev?)? , varlistentry+), got ()
Document linux-2.6.27-rc6-git4/Documentation/DocBook/debugobjects.xml does not validate
make[1]: *** [Documentation/DocBook/debugobjects.html] Error 3

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Roland McGrath <roland@redhat.com>
cc: Roland McGrath <roland@redhat.com>
cc: Christoph Hellwig <hch@infradead.org>
---
 scripts/kernel-doc |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.27-rc6-git4.orig/scripts/kernel-doc
+++ linux-2.6.27-rc6-git4/scripts/kernel-doc
@@ -781,6 +781,7 @@ sub output_struct_xml(%) {
     print " <refsect1>\n";
     print "  <title>Members</title>\n";
 
+    if ($#{$args{'parameterlist'}} >= 0) {
     print "  <variablelist>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
       ($parameter =~ /^#/) && next;
@@ -798,6 +799,9 @@ sub output_struct_xml(%) {
       print "    </varlistentry>\n";
     }
     print "  </variablelist>\n";
+    } else {
+	print " <para>\n  None\n </para>\n";
+    }
     print " </refsect1>\n";
 
     output_section_xml(@_);
