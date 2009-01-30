Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZA3PGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZA3PGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZA3PFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60154 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZA3PFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:32 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/8] checkpatch: make in_atomic ok in the core
Date: Fri, 30 Jan 2009 15:05:13 +0000
Message-Id: <1233327920-16691-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We say that in_atomic() is ok in the core kernel, but then always
report it regardless of where in the kernel it is.  Keep quiet if
it is used in kernel/*.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 45eb0ae..c71a0fa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2560,7 +2560,7 @@ sub process {
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
 				ERROR("do not use in_atomic in drivers\n" . $herecurr);
-			} else {
+			} elsif ($realfile !~ m@^kernel/@) {
 				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
-- 
1.6.1.2.419.g0d87e

