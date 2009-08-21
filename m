Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbZHUVq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbZHUVq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbZHUVqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59343 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbZHUVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:23 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 3/7] checkpatch: indent checks -- stop when we run out of continuation lines
Date: Fri, 21 Aug 2009 22:46:06 +0100
Message-Id: <1250891170-8599-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we terminate when there are no futher continuation lines when
trying to determine relative indent of conditionals and their blocks.

Reported-by: John Daiker <daikerjohn@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index aa009a3..b6f267b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1547,8 +1547,9 @@ sub process {
 				    $s =~ /^\s*#\s*?/ ||
 				    $s =~ /^\s*$Ident\s*:/) {
 					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
-					$s =~ s/^.*?\n//;
-					$cond_lines++;
+					if ($s =~ s/^.*?\n//) {
+						$cond_lines++;
+					}
 				}
 			}
 
-- 
1.6.3.3

