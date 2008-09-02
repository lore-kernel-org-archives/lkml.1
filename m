Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYIBR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYIBR0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYIBRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:22 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36130 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Julien Brunel <brunel@diku.dk>
Subject: [PATCH 2/7] checkpatch: suppress errors triggered by short patch
Date: Tue,  2 Sep 2008 18:25:09 +0100
Message-Id: <1220376314-15180-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the last hunk of a patch is short it will trigger errors from
checkpatch:

    Use of uninitialized value in pattern match (m//)
	    at /usr/local/bin/checkpatch.pl line 394.
    Use of uninitialized value in concatenation (.) or string
	    at /usr/local/bin/checkpatch.pl line 397.
    Use of uninitialized value in pattern match (m//)

Avoid touching beyond the last line.  Reported by Julien Brunel.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Julien Brunel <brunel@diku.dk>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 457f874..5382f72 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -408,6 +408,7 @@ sub ctx_statement_block {
 		# context.
 		if ($off >= $len) {
 			for (; $remain > 0; $line++) {
+				last if (!defined $lines[$line]);
 				next if ($lines[$line] =~ /^-/);
 				$remain--;
 				$loff = $len;
-- 
1.6.0.rc1.258.g80295

