Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZALMpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZALMpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZALMpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40577 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZALMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:11 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 5/6] checkpatch: struct seq_operations should normally be const
Date: Mon, 12 Jan 2009 12:45:03 +0000
Message-Id: <1231764304-1491-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the general use case struct seq_operations should be a const object.
Check for and warn where it is not.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5ea55e3..447435c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2527,9 +2527,10 @@ sub process {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
 # check for struct file_operations, ensure they are const.
-		if ($line =~ /\bstruct\s+file_operations\b/ &&
-		    $line !~ /\bconst\b/) {
-			WARN("struct file_operations should normally be const\n" . $herecurr);
+		if ($line !~ /\bconst\b/ &&
+		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+			WARN("struct $1 should normally be const\n" .
+				$herecurr);
 		}
 
 # use of NR_CPUS is usually wrong
-- 
1.6.0.4.911.gc990

