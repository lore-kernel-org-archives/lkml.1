Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYEAMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYEAMLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbYEAMKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:10:55 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4916 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbYEAMKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:10:54 -0400
Date: Thu, 1 May 2008 13:09:58 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] update checkpatch.pl to version 0.19
Message-ID: <20080501120958.GB20475@shadowen.org>
References: <1209639893.0@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209639893.0@pinky>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       return is not a function

Bah, no matter how much testing you do something always slips through.
This one is false triggering enough to warrent a fix.

Andrew, please suck this one up on top.

-apw

=== 8< ===
return is not a function -- tighten test

Tighten the return is not a function test so that we only report it on
the line it occurs.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>

---
diff --git a/checkpatch.pl b/checkpatch.pl
index cc9cd7c..66f060e 100755
--- a/checkpatch.pl
+++ b/checkpatch.pl
@@ -1665,7 +1665,7 @@ sub process {
 		}
 
 # Return is not a function.
-		if (defined($stat) && $stat =~ /\breturn(\s*)(\(.*);/s) {
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
 			my $spacing = $1;
 			my $value = $2;
 

