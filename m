Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYIBR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYIBR1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYIBRZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:39 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36164 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYIBRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:38 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Jaswinder Singh <jaswinder@infradead.org>
Subject: [PATCH 3/7] checkpatch: handle comment/quote nesting correctly
Date: Tue,  2 Sep 2008 18:25:10 +0100
Message-Id: <1220376314-15180-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that a close comment cannot incorrectly trigger in the middle
of a string.  Reported by Jaswinder Singh.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5382f72..18646f0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -335,7 +335,7 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
-		if (substr($line, $off, 2) eq '*/') {
+		if ($sanitise_quote eq '*/' && substr($line, $off, 2) eq '*/') {
 			$sanitise_quote = '';
 			substr($res, $off, 2, "$;$;");
 			$off++;
-- 
1.6.0.rc1.258.g80295

