Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZATKa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZATKa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZATKaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:30:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50152 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZATKaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:30:16 -0500
Date: Tue, 20 Jan 2009 11:32:19 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eric.piel@tremplin-utc.net, trenn@suse.de, linux-kernel@vger.kernel.org
Subject: checkpatch fun (was Re: hp accelerometer: add freefall detection)
Message-ID: <20090120103219.GK2576@elf.ucw.cz>
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net> <20090116121940.GA30302@elf.ucw.cz> <20090116143404.ccf2d9ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116143404.ccf2d9ee.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 14:34:04, Andrew Morton wrote:
> On Fri, 16 Jan 2009 13:19:40 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > new file mode 100755
> > index 0000000..7d17764
> > --- /dev/null
> > +++ b/Documentation/hwmon/hpfall.c
> 
> checkpatch has fun with this file.

Well, I have fun with checkpatch :-(.

pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl
hwmon/hpfall.c
ERROR: Does not appear to be a unified-diff format patch

total: 1 errors, 0 warnings, 0 lines checked

hwmon/hpfall.c has style problems, please review.  If any of these
errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -f
hwmon/hpfall.c
Unknown option: f
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -h
Unknown option: h
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl --help
Unknown option: help
pavel@amd:/data/l/linux/Documentation$ 

Ok, will fix.

> > -struct acpi_lis3lv02d adev;
> > +struct acpi_lis3lv02d adev = {
> > +	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
> > +};
> > +
> >  EXPORT_SYMBOL_GPL(adev);
> 
> This seems a rather poor name for a globally-visible identifier.

Hmm, right. lis_acpi_dev should be better. Will fix.

---

I tried checkpatch-ing a file, and not only my attempts to use it
failed, my attempts to get help failed too.

pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl hwmon/hpfall.c
ERROR: Does not appear to be a unified-diff format patch
....
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -f hwmon/hpfall.c
Unknown option: f
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl -h
Unknown option: h
pavel@amd:/data/l/linux/Documentation$ ../scripts/checkpatch.pl --help
Unknown option: help

Make -f alias of --file, and print help if user passes unknown option.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 4ef496ab198210648c310b8ae25872b9f99bee27
tree 1155a0dad369dc33362994bb6ff74868c7408f4c
parent f155017822e2fea0bc7434545cc63c2c8d363e59
author Pavel <pavel@suse.cz> Tue, 20 Jan 2009 11:31:52 +0100
committer Pavel <pavel@suse.cz> Tue, 20 Jan 2009 11:31:52 +0100

 scripts/checkpatch.pl |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 45eb0ae..c9eeda9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -28,6 +28,22 @@ my $mailback = 0;
 my $summary_file = 0;
 my $root;
 my %debug;
+
+sub help {
+	print "usage: $P [options] patchfile\n";
+	print "version: $V\n";
+	print "options: -q               => quiet\n";
+	print "         --no-tree        => run without a kernel tree\n";
+	print "         --terse          => one line per report\n";
+	print "         --emacs          => emacs compile window format\n";
+	print "         --file           => check a source file\n";
+	print "         --strict         => enable more subjective tests\n";
+	print "         --root           => path to the kernel tree root\n";
+	print "         --no-summary     => suppress the per-file summary\n";
+	print "         --summary-file   => include the filename in summary\n";
+	exit(1);
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -35,7 +51,7 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
-	'file!'		=> \$file,
+	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
@@ -45,23 +61,13 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
-) or exit;
+) or help;
 
 my $exit = 0;
 
+
 if ($#ARGV < 0) {
-	print "usage: $P [options] patchfile\n";
-	print "version: $V\n";
-	print "options: -q               => quiet\n";
-	print "         --no-tree        => run without a kernel tree\n";
-	print "         --terse          => one line per report\n";
-	print "         --emacs          => emacs compile window format\n";
-	print "         --file           => check a source file\n";
-	print "         --strict         => enable more subjective tests\n";
-	print "         --root           => path to the kernel tree root\n";
-	print "         --no-summary     => suppress the per-file summary\n";
-	print "         --summary-file   => include the filename in summary\n";
-	exit(1);
+    	help;
 }
 
 my $dbg_values = 0;



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
