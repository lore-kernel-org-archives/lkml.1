Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYJWLKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYJWLKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYJWLHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:07:00 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50763 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYJWLG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:59 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 1/9] checkpatch: add checks for in_atomic()
Date: Thu, 23 Oct 2008 12:06:31 +0100
Message-Id: <1224759999-21389-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in_atomic() is not for driver use so report any such use as an ERROR.
Also in_atomic() is often used to determine if we may sleep, but it is
not reliable in this use model therefore strongly discourage its use.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e30bac1..dbbf96f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2466,6 +2466,15 @@ sub process {
 				last;
 			}
 		}
+
+# whine mightly about in_atomic
+		if ($line =~ /\bin_atomic\s*\(/) {
+			if ($realfile =~ m@^drivers/@) {
+				ERROR("do not use in_atomic in drivers\n" . $herecurr);
+			} else {
+				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
1.6.0.2.711.gf1ba4

