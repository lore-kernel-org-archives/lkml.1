Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbZLOW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbZLOW2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbZLOW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:28:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42800 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748AbZLOW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=XOQf7gFTa9TScpYs+kj1sfuQPl0y8AvrQPvtdsf+I88f/lYLAbfT265Jl/Em6appFe
         3QR9OGiEUPKNOD0CSlW4a2E9mtchLMvK9BV7jCq0XMpvoVjKKRjMIeuw9IhVYxmQfWis
         RUj77zFZNq84i6qLP5w6ZQimwrX68x5LIi6+w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Tue, 15 Dec 2009 23:26:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Message-Id: <200912152326.34728.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009 10:57:49 pm Mikulas Patocka wrote:

> But some maintainers take output of the script checkpatch.pl dogmatically,
> requiring that every new work must pass the script without a warning. This is
> counterproductive --- if I write a driver and I will be doing most maintenance
> work on it in the future, it is viable that the driver is formatted in such
> a way that is best editable for me, not for anyone else. And as shown in example
> (1), this 80-column requirement makes even simple changes much harder.

It has been agreed in the past that 80-column warnings shouldn't result
automatically in the rejection of the new hardware support so the above
argumentation is a bit weak.

> So: I am submitting this patch for the checkpatch.pl script.
> 
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Having this limitation makes people at least think about designing their
code properly and making it more compact.

If you don't want to see such warnings just apply the following patch that
I've been keeping locally (it helped me to work on staging drivers):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] checkpatch.pl: add option to disable 80 column limit check

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/scripts/checkpatch.pl
===================================================================
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -17,6 +17,7 @@ use Getopt::Long qw(:config no_auto_abbr
 my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
+my $chk_cl = 1;
 my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
@@ -41,6 +42,7 @@ Options:
   -q, --quiet                quiet
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-cl                    do not apply 80 column limit
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -67,6 +69,7 @@ GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'cl!'		=> \$chk_cl,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -1365,7 +1368,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
+		if ($chk_cl && $line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
 		    $length > 80)
