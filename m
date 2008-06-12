Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbYFLMJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbYFLMJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbYFLMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4317 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153AbYFLMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:52 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 04/23] checkpatch: add a checkpatch warning for new uses of __initcall().
Date: Thu, 12 Jun 2008 13:05:43 +0100
Message-Id: <1213272362-19457-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

[apw@shadowen.org: generalise pattern and add tests]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5420db6..cf70f12 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2108,6 +2108,10 @@ sub process {
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
 			WARN("consider using strict_$1 in preference to simple_$1\n" . $herecurr);
 		}
+# check for __initcall(), use device_initcall() explicitly please
+		if ($line =~ /^.\s*__initcall\s*\(/) {
+			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
-- 
1.5.6.rc0.140.ga9675

