Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbYDYSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbYDYSKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765170AbYDYSIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:08:34 -0400
Received: from vena.lwn.net ([206.168.112.25]:49259 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765475AbYDYSIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:08:30 -0400
To: torvalds@linux-foundation.org
Subject: [PULL] A few documentation updates
cc: greg@kroah.com, viro@parcelfarce.linux.theplanet.co.uk,
       linux-kernel@vger.kernel.org
From: Jonathan Corbet <corbet@lwn.net>
Date: Fri, 25 Apr 2008 12:08:28 -0600
Message-ID: <2501.1209146908@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few updates queued up in my documentation tree:

  git://git.lwn.net/linux-2.6 docs

Changes are:

Jonathan Corbet (3):
      Document SEQ_SKIP
      Various fixes to Documentation/HOWTO
      Document seq_path_root()

 Documentation/HOWTO                    |   30 +++++++++++++++++++-----------
 Documentation/filesystems/seq_file.txt |   19 +++++++++++++++----
 2 files changed, 34 insertions(+), 15 deletions(-)

The diff is small, so I'll just put it here for the curious:

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 5483561..0291ade 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -249,9 +249,11 @@ process is as follows:
     release a new -rc kernel every week.
   - Process continues until the kernel is considered "ready", the
     process should last around 6 weeks.
-  - A list of known regressions present in each -rc release is
-    tracked at the following URI:
-    http://kernelnewbies.org/known_regressions
+  - Known regressions in each release are periodically posted to the 
+    linux-kernel mailing list.  The goal is to reduce the length of 
+    that list to zero before declaring the kernel to be "ready," but, in
+    the real world, a small number of regressions often remain at 
+    release time.
 
 It is worth mentioning what Andrew Morton wrote on the linux-kernel
 mailing list about kernel releases:
@@ -261,7 +263,7 @@ mailing list about kernel releases:
 
 2.6.x.y -stable kernel tree
 ---------------------------
-Kernels with 4 digit versions are -stable kernels. They contain
+Kernels with 4-part versions are -stable kernels. They contain
 relatively small and critical fixes for security problems or significant
 regressions discovered in a given 2.6.x kernel.
 
@@ -273,7 +275,10 @@ If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
 kernel is the current stable kernel.
 
 2.6.x.y are maintained by the "stable" team <stable@kernel.org>, and are
-released almost every other week.
+released as needs dictate.  The normal release period is approximately 
+two weeks, but it can be longer if there are no pressing problems.  A
+security-related problem, instead, can cause a release to happen almost
+instantly.
 
 The file Documentation/stable_kernel_rules.txt in the kernel tree
 documents what kinds of changes are acceptable for the -stable tree, and
@@ -298,7 +303,9 @@ a while Andrew or the subsystem maintainer pushes it on to Linus for
 inclusion in mainline.
 
 It is heavily encouraged that all new patches get tested in the -mm tree
-before they are sent to Linus for inclusion in the main kernel tree.
+before they are sent to Linus for inclusion in the main kernel tree.  Code
+which does not make an appearance in -mm before the opening of the merge
+window will prove hard to merge into the mainline.
 
 These kernels are not appropriate for use on systems that are supposed
 to be stable and they are more risky to run than any of the other
@@ -354,11 +361,12 @@ Here is a list of some of the different kernel trees available:
     - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
 	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
+    - x86, Ingo Molnar <mingo@elte.hu>
+	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+
   quilt trees:
-    - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
+    - USB, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
-    - x86-64, partly i386, Andi Kleen <ak@suse.de>
-        ftp.firstfloor.org:/pub/ak/x86_64/quilt/
 
   Other kernel trees can be found listed at http://git.kernel.org/ and in
   the MAINTAINERS file.
@@ -392,8 +400,8 @@ If you want to be advised of the future bug reports, you can subscribe to the
 bugme-new mailing list (only new bug reports are mailed here) or to the
 bugme-janitor mailing list (every change in the bugzilla is mailed here)
 
-	http://lists.osdl.org/mailman/listinfo/bugme-new
-	http://lists.osdl.org/mailman/listinfo/bugme-janitors
+	http://lists.linux-foundation.org/mailman/listinfo/bugme-new
+	http://lists.linux-foundation.org/mailman/listinfo/bugme-janitors
 
 
 
diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 7fb8e6d..b843743 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -122,8 +122,7 @@ stop() is the place to free it.
 	}
 
 Finally, the show() function should format the object currently pointed to
-by the iterator for output. It should return zero, or an error code if
-something goes wrong. The example module's show() function is:
+by the iterator for output.  The example module's show() function is:
 
 	static int ct_seq_show(struct seq_file *s, void *v)
 	{
@@ -132,6 +131,12 @@ something goes wrong. The example module's show() function is:
 	        return 0;
 	}
 
+If all is well, the show() function should return zero.  A negative error
+code in the usual manner indicates that something went wrong; it will be
+passed back to user space.  This function can also return SEQ_SKIP, which
+causes the current item to be skipped; if the show() function has already
+generated output before returning SEQ_SKIP, that output will be dropped.
+
 We will look at seq_printf() in a moment. But first, the definition of the
 seq_file iterator is finished by creating a seq_operations structure with
 the four functions we have just defined:
@@ -182,12 +187,18 @@ The first two output a single character and a string, just like one would
 expect. seq_escape() is like seq_puts(), except that any character in s
 which is in the string esc will be represented in octal form in the output.
 
-There is also a function for printing filenames:
+There is also a pair of functions for printing filenames:
 
 	int seq_path(struct seq_file *m, struct path *path, char *esc);
+	int seq_path_root(struct seq_file *m, struct path *path,
+			  struct path *root, char *esc)
 
 Here, path indicates the file of interest, and esc is a set of characters
-which should be escaped in the output.
+which should be escaped in the output.  A call to seq_path() will output
+the path relative to the current process's filesystem root.  If a different
+root is desired, it can be used with seq_path_root().  Note that, if it
+turns out that path cannot be reached from root, the value of root will be
+changed in seq_file_root() to a root which *does* work.
 
 
 Making it all work
