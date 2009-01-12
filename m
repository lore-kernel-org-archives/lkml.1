Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZALMq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZALMq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZALMpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40647 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZALMpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:12 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 4/6] checkpatch: if should not continue a preceeding brace
Date: Mon, 12 Jan 2009 12:45:02 +0000
Message-Id: <1231764304-1491-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be continuing a braced section with an if, for example:

	if (...) {
	} if (...) {
	}

Detect this and suggest adding a newline.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 696196e..5ea55e3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2108,6 +2108,11 @@ sub process {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
+# if should not continue a brace
+		if ($line =~ /}\s*if\b/) {
+			ERROR("trailing statements should be on next line\n" .
+				$herecurr);
+		}
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
 		    $line !~ /\G(?:
-- 
1.6.0.4.911.gc990

