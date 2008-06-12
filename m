Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYFLMJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYFLMJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYFLMHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:52 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4316 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbYFLMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:50 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 02/23] checkpatch: return is not a function -- parentheses for casts are ok too
Date: Thu, 12 Jun 2008 13:05:41 +0100
Message-Id: <1213272362-19457-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casts require parentheses so it is possible to have something like this:

	return (int)(*a);

This miss trips the complexity function.  Ensure that the two separate
parenthesised sections are not coelesced.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 66f060e..83ae37b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1670,6 +1670,7 @@ sub process {
 			my $value = $2;
 
 			# Flatten any parentheses and braces
+			$value =~ s/\)\(/\) \(/g;
 			while ($value =~ s/\([^\(\)]*\)/1/) {
 			}
 
-- 
1.5.6.rc0.140.ga9675

