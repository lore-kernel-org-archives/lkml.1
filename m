Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXEaTaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXEaTaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbXEaTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:30:06 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48371 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934AbXEaTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:30:04 -0400
Date: Thu, 31 May 2007 21:26:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
Message-ID: <Pine.LNX.4.61.0705312120320.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>+sub top_of_kernel_tree {
>+	if ((-f "COPYING") && (-f "CREDITS") && (-f "Kbuild") &&
>+	    (-f "MAINTAINERS") && (-f "Makefile") && (-f "README") &&
>+	    (-d "Documentation") && (-d "arch") && (-d "include") &&
>+	    (-d "drivers") && (-d "fs") && (-d "init") && (-d "ipc") &&
>+	    (-d "kernel") && (-d "lib") && (-d "scripts")) {
>+		return 1;
>+	}
>+	return 0;
>+}

Looks like some redundant parentheses.

>+#gotos aren't indented
>+		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>+			print "Gotos should not be indented\n";
>+			print "$herecurr";
>+			$clean = 0;
>+		}

I think this was discussed already - some indent (1 space?) should be allowed.

>+#studly caps, commented out until figure out how to distinguish between use
>+#of existing and adding new

Yeah that's a big problem, given that linux's mm/ directory has
quite a lot of camel case function names.

>+#		if(($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
>+#		    print ("No studly caps, use _\n");
>+#		    print "$herecurr";
>+#		    $clean = 0;
>+#		}
>+
>+#no spaces allowed after \ in define
>+		if($line=~/\#define.*\\\s$/){

Usually, #s do _not_ need to be quoted (in contrast to @).
I am at stake to be wrong, anyone know more? :)

>+#if/while/etc brace do not go on next line, unless #defining a do while loop, or if that brace on the next line is for something else
>+		if ($prevline=~/(if|while|for|switch)\s*\(/) {

/(?:if|while|.../

I don't see $1 being captured/used, so..

>+			my @opened = $prevline=~/\(/g;
>+			my @closed = $prevline=~/\)/g;
>+			my $nr_line = $linenr;
>+			my $remaining = $realcnt;
>+			my $next_line = $line;
>+			my $extra_lines = 0;
>+			my $display_segment = $prevline;
>+
>+			while ($remaining > 0 && scalar @opened > scalar @closed) {
>+				$prevline .= $next_line;
>+				$display_segment .= "\n" . $next_line;
>+				$next_line = $lines[$nr_line];
>+				$nr_line++;
>+				$remaining--;
>+
>+				@opened = $prevline=~/\(/g;
>+				@closed = $prevline=~/\)/g;
>+			}
>+
>+			if(($prevline=~/(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
>+			   !($next_line=~/(if|while|for)/) and !($next_line=~/\#define.*do.*while/)) {

Same.

>+# don't include <linux/video_decoder.h>

Who does that?



	Jan
-- 
