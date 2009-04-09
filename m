Return-Path: <linux-kernel-owner+w=401wt.eu-S937308AbZDIX0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937308AbZDIX0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbZDIX0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:26:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbZDIX0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:26:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904091458330.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091458330.4583@localhost.localdomain> <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <11730.1239311156@redhat.com> <12327.1239313897@redhat.com> 
To: catalin.marinas@arm.com
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Fix for StGIT
Date: Fri, 10 Apr 2009 00:24:41 +0100
Message-ID: <13288.1239319481@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Catalin,

I think StGIT needs something like the attached patch to get it to generate
patches with renames in them correctly.  This isn't quite right, since it
doesn't pass the file list to git-diff-tree, but I can't work out how to make
the python do it:-/

David
---
diff -c /usr/lib/python2.5/site-packages/stgit/git.py.old /usr/lib/python2.5/site-packages/stgit/git.py
--- /usr/lib/python2.5/site-packages/stgit/git.py.old	2008-06-08 23:26:03.000000000 +0100
+++ /usr/lib/python2.5/site-packages/stgit/git.py	2009-04-10 00:17:58.000000000 +0100
@@ -820,8 +820,8 @@
 # usually invoke git.diff() form the calling functions
 def diffstat(files = None, rev1 = 'HEAD', rev2 = None):
     """Return the diffstat between rev1 and rev2."""
-    return GRun('apply', '--stat', '--summary'
-                ).raw_input(diff(files, rev1, rev2)).raw_output()
+    return GRun('diff-tree', '-M', '--stat', '--summary', rev1, rev2
+                ).raw_output()
 
 def files(rev1, rev2, diff_flags = []):
     """Return the files modified between rev1 and rev2
