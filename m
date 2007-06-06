Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXFFMkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXFFMkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXFFMk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:40:29 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:32821 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752557AbXFFMk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:40:29 -0400
Date: Wed, 6 Jun 2007 14:40:24 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andy Whitcroft <apw@shadowen.org>, Dave Jones <davej@redhat.com>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add a trivial patch style checker v2
In-Reply-To: <735b25fd823d649f9cf55b63eb878b63@pinky>
Message-ID: <Pine.LNX.4.62.0706061433430.10542@pademelon.sonytel.be>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <735b25fd823d649f9cf55b63eb878b63@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Andy Whitcroft wrote:
> As a first step package up the current state of the patch style
> checker and include it in the kernel tree.  Add instructions
> suggesting running it on submissions.  This adds version v0.01 of
                                                           ^^^^^
> the checkpatch.pl script.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> 	Ok, here is V2 of the checker.	A lot of feedback has been
                    ^^
> --- /dev/null
> +++ b/scripts/checkpatch.pl
> @@ -0,0 +1,595 @@
> +#!/usr/bin/perl -w
> +# (c) 2001, Dave Jones. <davej@codemonkey.org.uk> (the file handling bit)
> +# (c) 2005, Joel Scohpp <jschopp@austin.ibm.com> (the ugly bit)
> +# (c) 2007, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite, etc)
> +# Licensed under the terms of the GNU GPL License version 2
> +
> +use strict;
> +
> +my $P = $0;
> +
> +my $V = '0.01';
            ^^^^
So, what's the correct version number? ;-)

Will http://www.codemonkey.org.uk/projects/checkpatch/checkpatch.git/ (hey, a
project with the same name started by the same person???) be merged in?

Below is a small fix for the wrong hardcoded script name

---
Subject: [PATCH] Fix checkpatch.pl name in usage template

Fix checkpatch.pl name in usage template:
  - Don't use wrong hardcoded script name
  - Strip dirname from command name

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -7,6 +7,7 @@
 use strict;
 
 my $P = $0;
+$P =~ s@.*/@@g;
 
 my $V = '0.01';
 
@@ -26,7 +27,7 @@ GetOptions(
 my $exit = 0;
 
 if ($#ARGV < 0) {
-	print "usage: patchstylecheckemail.pl [options] patchfile\n";
+	print "usage: $P [options] patchfile\n";
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
