Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYAPWbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYAPWbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYAPWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:21:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbYAPWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:21:25 -0500
Date: Wed, 16 Jan 2008 23:21:21 +0100
From: Andi Kleen <ak@suse.de>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Deprecate checkpatch.pl --file mode; add warning; add --file-force
Message-ID: <20080116222121.GA7185@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not entirely sure who collects checkpatch patches for .25 -- i thought it
was Andy W., but he doesn't seem to answer. Anyways whoever does it please
queue this patch for the next checkpatch.pl update. Or perhaps it could
be put into -mm?

Thanks,
-Andi
----

Deprecate checkpatch.pl --file mode; add warning; add --file-force

As discussed on linux-kernel checkpatch.pl only patches for whole
files have a significant cost. Better such changes should be only
done together with other changes. Add a explicit warning about
this; deprecate --file and add a --file-force instead.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 scripts/checkpatch.pl |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl
+++ linux/scripts/checkpatch.pl
@@ -21,6 +21,7 @@ my $tst_type = 0;
 my $emacs = 0;
 my $terse = 0;
 my $file = 0;
+my $file_force = 0;
 my $check = 0;
 my $summary = 1;
 my $mailback = 0;
@@ -34,6 +35,7 @@ GetOptions(
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
 	'file!'		=> \$file,
+	'file-force!'	=> \$file_force,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
@@ -50,12 +52,28 @@ if ($#ARGV < 0) {
 	print "         --no-tree    => run without a kernel tree\n";
 	print "         --terse      => one line per report\n";
 	print "         --emacs      => emacs compile window format\n";
-	print "         --file       => check a source file\n";
+	print " 	--file	     => check a source file (deprecated)\n";
+	print " 	--file-force => check a source file\n";
 	print "         --strict     => enable more subjective tests\n";
 	print "         --root       => path to the kernel tree root\n";
 	exit(1);
 }
 
+if ($file) {
+	print <<EOL
+WARNING: Using --file mode. Please do not send patches to linux-kernel
+that change whole existing files if you did not significantly change most
+of the the file for other reasons anyways or just wrote the file newly
+from scratch. Pure code style patches have a significant cost in a
+quickly changing code base like Linux because they cause rejects
+with other changes.
+If you're sure you want to use whole file mode please use --file-force
+EOL
+;
+	exit(1);
+};
+$file = $file_force;
+
 if ($terse) {
 	$emacs = 1;
 	$quiet++;
