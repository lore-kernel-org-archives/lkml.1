Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZFARqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZFARqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZFARqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:46:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1960 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZFARqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:46:11 -0400
Subject: Script to integrate MAINTAINERS P: and M: lines
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090527151510.fb773db6.akpm@linux-foundation.org>
References: <cover.1243131992.git.joe@perches.com>
	 <136e58c251157179f19a7eecedd1e6fe71a3e6d9.1243131992.git.joe@perches.com>
	 <20090526144141.570594cf.akpm@linux-foundation.org>
	 <1243455722.27337.65.camel@Joe-Laptop.home>
	 <20090527151510.fb773db6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 10:45:31 -0700
Message-Id: <1243878331.3402.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a script to convert the MAINTAINERS file
to a single-line format.

from:
	P:	name
	M:	address
to
	M:	name <address>

Please run the script and apply the result when convenient.

--- /dev/null	2009-05-30 11:29:04.000000000 -0700
+++ integrate_maintainers.sh	2009-06-01 10:27:06.000000000 -0700
@@ -0,0 +1,39 @@
+#! /bin/sh
+#
+# Change MAINTAINERS from
+#	P: name
+#	M: address
+# to:
+#	M: name <address>
+#
+# Integrate P: and M: lines
+#
+perl -i -e 'local $/; while(<>) { s@P:	([^\n]+)\nM:	([^\n]+)\n@M:	\1 <\2>\n@g; print; }' MAINTAINERS
+#
+# Quote names with periods, commas and parentheses
+#
+sed -r -i -e "s/^M:	(.+)([\.,'\(])(.*) </M:	\"\1\2\3\" </g" MAINTAINERS
+#
+# Fix CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER section names
+#
+sed -r -i -e 's/"Nils Faerber \(port to kernel 2.4\) <Nils Faerber\" <nils@kernelconcepts.de>>/"Nils Faerber \(port to kernel 2.4\)" <nils@kernelconcepts.de>/g' MAINTAINERS
+sed -r -i -e 's/"Cirrus Logic Corporation \(kernel 2.2 driver\) <Cirrus Logic Corporation, Thomas Woller" <twoller@crystal.cirrus.com>>/"Cirrus Logic Corporation \(kernel 2.2 driver\), Thomas Woller" <twoller@crystal.cirrus.com>/g' MAINTAINERS
+#
+# Add a description of email name style
+#
+patch -p1 <<EOF
+diff --git a/MAINTAINERS b/MAINTAINERS
+--- a/MAINTAINERS
++++ b/MAINTAINERS
+@@ -67,8 +67,8 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
+ order. If you could add yourselves to it in alphabetical order that would be
+ so much easier [Ed]
+ 
+-P: Person
+-M: Mail patches to
++P: Person (obsolete)
++M: Mail patches to: FullName <address@domain>
+ L: Mailing list that is relevant to this area
+ W: Web-page with status/info
+ T: SCM tree type and location.  Type is one of: git, hg, quilt.
+EOF


