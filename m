Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYLGSeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYLGSeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYLGSbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:09 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55720 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYLGSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:08 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 09/13] checkpatch: do not report nr_static as a static declaration
Date: Sun,  7 Dec 2008 18:30:46 +0000
Message-Id: <1228674650-24392-10-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Ensure we do not report identifiers containing the word static as static
declarations.  For example this should not be reported as an unecessary
assignement of 0:

	long nr_static = 0;

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 906624c..a521d49 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1632,7 +1632,7 @@ sub process {
 				$herecurr);
 		}
 # check for static initialisers.
-		if ($line =~ /\s*static\s.*=\s*(0|NULL|false)\s*;/) {
+		if ($line =~ /\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
-- 
1.6.0.4.911.gc990

