Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYE3Uew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYE3Uew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYE3Ueo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:34:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752906AbYE3Uen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:34:43 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Randy Dunlap" <rdunlap@xenotime.net>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 30 May 2008 13:34:42 -0700
Message-Id: <20080530203442.29524.9752.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH] doc: document the kernel-doc conventions for kernel hackers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Provide documentation of the kernel-doc documentation conventions
oriented to kernel hackers.

Since I figure that there will be more people reading this
kernel-doc-nano-HOWTO.txt file who are kernel developers focused
on the rest of the kernel, than there will be readers of this
file who are documentation developers extracting that embedded
kernel-doc documentation, I have taken the liberty of making
the new section added here:

  How to format kernel-doc comments

the first section of the kernel-doc-nano-HOWTO.txt file.

This first section is intended to introduce, motivate and
provide basic usage of the kernel-doc mechanism for kernel
hackers developing other portions of the kernel.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 Documentation/kernel-doc-nano-HOWTO.txt |   99 ++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

--- linux-2.6.orig/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 08:47:13.000000000 -0700
+++ linux-2.6/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 13:31:07.111325343 -0700
@@ -1,6 +1,105 @@
 kernel-doc nano-HOWTO
 =====================
 
+How to format kernel-doc comments
+---------------------------------
+
+In order to provide an embedded, 'C' friendly, easy to maintain,
+but consistent and extractable documentation of the functions and
+data structures in the Linux kernel, the Linux kernel has adopted
+a consistent style for documenting functions and their parameters,
+and structures and their members.
+
+The format for this documentation is called the kernel-doc format.
+It as documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
+
+This style embeds the documentation within the source files, using
+a few simple conventions.  The scripts/kernel-doc perl script, some
+SGML templates in Documentation/DocBook, and other tools understand
+these conventions, and are used to extract this embedded documentation
+into various documents.
+
+In order to provide good documentation of kernel functions and data
+structures, please use the following conventions to format your
+kernel-doc comments in Linux kernel source.
+
+We definitely need kernel-doc formatted documentation for functions
+that are exported to loadable modules using EXPORT_SYMBOL.
+
+We also look to provide kernel-doc formatted documentation for
+functions externally visible to other kernel files (not marked
+"static").
+
+We also recommend providing kernel-doc formatted documentation
+for private (file "static") routines, for consistency of kernel
+source code layout.  But this is lower priority and at the
+discretion of the MAINTAINER of that kernel source file.
+
+Data structures visible in kernel include files should also be
+documented using kernel-doc formatted comments.
+
+The opening comment mark "/**" is reserved for kernel-doc comments.
+Only comments so marked will be considered by the kernel-doc scripts,
+and any comment so marked must be in kernel-doc format.  Do not use
+"/**" to be begin a comment block unless the comment block contains
+kernel-doc formatted comments.  The closing comment marker for
+kernel-doc comments can be either "*/" or "**/".
+
+Kernel-doc comments should be placed just before the function
+or data structure being describe.
+
+Example kernel-doc function comment:
+
+/**
+ * foobar() - short function description of foobar
+ * @arg1:	Describe the first argument to foobar.
+ * @arg2:	Describe the second argument to foobar.
+ *              One can provide multiple line descriptions
+ *              for arguments.
+ *
+ * A longer description, with more discussion of the function foobar()
+ * that might be useful to those using or modifying it.  Begins with
+ * empty comment line, and may include additional embedded empty
+ * comment lines.
+ *
+ * The longer description can have multiple paragraphs.
+ **/
+
+The first line, with the short description, must be on a single line.
+
+The @argument descriptions must begin on the very next line following
+this opening short function description line, with no intervening
+empty comment lines.
+
+Example kernel-doc data structure comment.
+
+/**
+ * struct blah - the basic blah structure
+ * @mem1:       describe the first member of struct blah
+ * @mem2:	describe the second member of struct blah,
+ *		perhaps with more lines and words.
+ *
+ * Longer description of this structure.
+ **/
+
+The kernel-doc function comments describe each parameter to the
+function, in order, with the @name lines.
+
+The kernel-doc data structure comments describe each structure member
+in the data structure, with the @name lines.
+
+The longer description formatting is "reflowed", loosing your line
+breaks.  So presenting carefully formatted lists within these
+descriptions won't work so well; derived documentation will loose
+the formatting.
+
+See the section below "How to add extractable documentation to your
+source files" for more details and notes on how to format kernel-doc
+comments.
+
+Components of the kernel-doc system
+-----------------------------------
+
 Many places in the source tree have extractable documentation in the
 form of block comments above functions.  The components of this system
 are:

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
