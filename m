Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZA3PHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZA3PHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZA3PFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60180 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZA3PFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:34 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/8] checkpatch: do not warn about -p0 patches when checking files
Date: Fri, 30 Jan 2009 15:05:14 +0000
Message-Id: <1233327920-16691-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are triggering the -p0 check for our own diffs generated using
--file command line option.  Suppress this check for files.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c71a0fa..5ffc940 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1240,7 +1240,8 @@ sub process {
 			$realfile =~ s@^([^/]*)/@@;
 
 			$p1_prefix = $1;
-			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
+			if (!$file && $tree && $p1_prefix ne '' &&
+			    -e "$root/$p1_prefix") {
 				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
 			}
 
-- 
1.6.1.2.419.g0d87e

