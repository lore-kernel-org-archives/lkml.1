Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZJPSkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZJPSkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZJPSkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:03 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53020 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZJPSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:39:59 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/7] checkpatch: correctly stop scanning at the bottom of a hunk
Date: Fri, 16 Oct 2009 19:39:27 +0100
Message-Id: <1255718372-22805-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are allowing context scanning checks to apply against the first line
of context outside at the end of the hunk.  This can lead to false
matches to patch names leading to various perl warnings.  Correctly stop
at the bottom of the hunk.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b43e309..1eca1e1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1234,7 +1234,6 @@ sub process {
 		$linenr++;
 
 		my $rawline = $rawlines[$linenr - 1];
-		my $hunk_line = ($realcnt != 0);
 
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
@@ -1274,6 +1273,8 @@ sub process {
 			$realcnt--;
 		}
 
+		my $hunk_line = ($realcnt != 0);
+
 #make up the handle for any error we report on this line
 		$prefix = "$filename:$realline: " if ($emacs && $file);
 		$prefix = "$filename:$linenr: " if ($emacs && !$file);
-- 
1.6.3.3

