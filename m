Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYHKUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYHKUOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYHKUNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:21 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41164 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 04/17] checkpatch: switch indent allow plain return
Date: Mon, 11 Aug 2008 21:12:59 +0100
Message-Id: <1218485592-6679-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a common and sane idiom to allow a single return on the end
of a case statement:

	switch (...) {
	case foo:	return bar;
	}

Add an exception for this.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1e7d2cd..c6782ac 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1295,7 +1295,11 @@ sub process {
 			}
 		}
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
-		    $line !~ /\G(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$/g) {
+		    $line !~ /\G(?:
+			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			\s*return\s+
+		    )/xg)
+		{
 			ERROR("trailing statements should be on next line\n" . $herecurr);
 		}
 
-- 
1.6.0.rc1.258.g80295

