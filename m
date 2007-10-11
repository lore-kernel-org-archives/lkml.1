Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXJKM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXJKM2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXJKM2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:28:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38264 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbXJKM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:28:40 -0400
Date: Thu, 11 Oct 2007 08:28:00 -0400
From: "Mike D. Day" <ncmike@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@shadowen.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] fix minor problems in checkpatch.pl-next
Message-ID: <20071011122800.GA10216@silverwood.ncultra.org>
Reply-To: ncmike@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-PGP-Key: http://www.ncultra.org/ncmike/pubkey.asc
X-PGP-Fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
x-gpg-key: http://www.ncultra.org/ncmike/pubkey.asc
x-gpg-fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
Organization: IBM Linux Technology Center
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When forming the prefix to output error msgs in gnu gcc format, the
lack of a type ($ or @) when referencing ARGV causes error messages.

When invoked to check source files, the linenumber was off by +3 in
the gcc format output.

Signed-off-by: Mike D. Day <ncmike@ncultra.org>

--- checkpatch.pl-next	2007-10-11 07:28:41.000000000 -0400
+++ /home/mdday/bin/checkpatch	2007-10-11 08:16:07.000000000 -0400
@@ -452,7 +452,6 @@
 
 		my $rawline = $line;
 
-		$prefix = "ARGV:$linenr: " if ($emacs);
 
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
@@ -517,6 +516,9 @@
 		my $herecurr = "$here\n$line\n";
 		my $hereprev = "$here\n$prevline\n$line\n";
 
+		$prefix = "@ARGV:$realline: " if ($emacs && $file);
+		$prefix = "@ARGV:$linenr: " if ($emacs && !$file);
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.

-- 
Mike Day
http://www.ncultra.org
AIM: ncmikeday |  Yahoo IM: ultra.runner
PGP key: http://www.ncultra.org/ncmike/pubkey.asc
