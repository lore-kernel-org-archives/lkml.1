Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXHPGRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXHPGRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXHPGRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:17:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbXHPGRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:17:05 -0400
Date: Thu, 16 Aug 2007 13:22:15 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: apw@shadowen.org
Cc: linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
	expr
Message-ID: <20070816052215.GA3857@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make checkpatch rant about trailing ; at the end of "if" expression.

Thanks to Auke for the regexp.

Signed-off by: Eugene Teo <eugeneteo@kernel.sg>

--- checkpatch.pl-0.09.default	2007-08-03 23:31:40.000000000 +0800
+++ checkpatch.pl-0.09	2007-08-16 13:18:40.000000000 +0800
@@ -1091,6 +1091,12 @@ sub process {
 				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
+
+# checks for trailing ; at the end of "if" expression
+		if ($line =~ /\bif\s*\([^\)]*\)\s*\;/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("trailing ;\n" . $herevet);
+		}
 	}
 
 	if ($chk_patch && !$is_patch) {
