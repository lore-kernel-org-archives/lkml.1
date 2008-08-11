Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYHKUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYHKUTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYHKUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:25 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41272 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993AbYHKUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:24 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 14/17] checkpatch: %Lx tests should hand %% as a literal
Date: Mon, 11 Aug 2008 21:13:09 +0100
Message-Id: <1218485592-6679-15-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we handle literal %'s correctly when adjacent to a %Lx.

	%Lx	bad
	%%Lx	good
	%%%Lx	bad

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6ddae89..c7980ff 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2392,6 +2392,7 @@ sub process {
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			$string =~ s/%%/__/g;
 			if ($string =~ /(?<!%)%L[udi]/) {
 				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
-- 
1.6.0.rc1.258.g80295

