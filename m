Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYBLWDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYBLWDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYBLWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:03:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYBLWD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:03:26 -0500
Message-Id: <200802122156.m1CLufgn013359@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 12 Feb 2008 13:52:37 -0800
Subject: [PATCH] timeconst.pl: correct reversal of USEC_TO_HZ and HZ_TO_USEC
Cc: Eric Piel <E.A.B.Piel@tudelft.nl>, "Carlos R. Mafra" <crmafra@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USEC_TO_HZ and HZ_TO_USEC constant sets were mislabelled, with
seriously incorrect results.  This among other things manifested
itself as cpufreq not working when a tickless kernel was configured.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/timeconst.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index 62b1287..4146803 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -339,7 +339,7 @@ sub output($@)
 	print "\n";
 
 	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
-		      'USEC_TO_HZ','HZ_TO_USEC') {
+		      'HZ_TO_USEC','USEC_TO_HZ') {
 		foreach $bit (32, 64) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
 				printf "#define %-23s %s\n",
-- 
1.5.3.8

