Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYAHQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYAHQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYAHQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:14:08 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:23025 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbYAHQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:14:06 -0500
Date: Tue, 8 Jan 2008 17:14:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: apw@shadowen.org, akpm@osdl.org
Subject: [PATCH] Deprecate checkpatch.pl --file
Message-ID: <20080108161403.GA11632@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Jan 2008 16:07:55.0463 (UTC) FILETIME=[A1076570:01C85210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Deprecate checkpatch.pl --file mode; add warning; add --file-force

As discussed on linux-kernel checkpatch.pl only patches for whole
files have a significant cost for the maintenance process. 

Better such changes should be only
done together with other changes. Add a explicit warning about
this; deprecate --file and add a --file-force instead.

Signed-off-by: Andi Kleen <ak@suse.de>

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
+	print "         --file       => check a source file (deprecated)\n";
+	print "		--file-force => check a source file\n";
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
