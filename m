Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbXHHCpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbXHHCpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXHHCoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:44:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbXHHCox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:44:53 -0400
Date: Tue, 7 Aug 2007 22:43:21 -0400
From: Dave Jones <davej@redhat.com>
To: apw@shadowen.org
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Make checkpatch warn about pointless casting of kalloc returns.
Message-ID: <20070808024321.GA6316@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, apw@shadowen.org,
	rdunlap@xenotime.net, jschopp@austin.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make checkpatch warn about pointless casting of kalloc returns.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 73751ab..c6cae6a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1051,6 +1051,11 @@ sub process {
 				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
+
+# check for pointless casting of kmalloc return
+		if ($rawline =~ /\*\)[ ]k[czm]alloc/) {
+			WARN("No need to cast return value.\n");
+		}
 	}
 
 	if ($chk_patch && !$is_patch) {
-- 
http://www.codemonkey.org.uk
