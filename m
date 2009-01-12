Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZALMp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZALMp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZALMpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40634 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZALMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:11 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/6] checkpatch: handle missing #if open in context
Date: Mon, 12 Jan 2009 12:44:59 +0000
Message-Id: <1231764304-1491-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the #if opening statement is not in the context then the context
stack can be empty.  Handle this by ensuring there is always a blank
entry in the stack.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7bed4ed..eefef65 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -411,13 +411,15 @@ sub ctx_statement_block {
 
 	my $type = '';
 	my $level = 0;
-	my @stack = ([$type, $level]);
+	my @stack = ();
 	my $p;
 	my $c;
 	my $len = 0;
 
 	my $remainder;
 	while (1) {
+		@stack = (['', 0]) if ($#stack == -1);
+
 		#warn "CSB: blk<$blk> remain<$remain>\n";
 		# If we are about to drop off the end, pull in more
 		# context.
-- 
1.6.0.4.911.gc990

