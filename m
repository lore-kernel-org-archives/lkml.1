Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbZEXCkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbZEXCkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZEXCiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:11 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1431 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] scripts/get_maintainer.pl - Don't print maintainers when not requested
Date: Sat, 23 May 2009 19:37:39 -0700
Message-Id: <25e22747f536fc53cd7e01f84c0ede3433703e68.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed bug introduced after using rfc822 address checking.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 33872c7..9de864f 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -436,10 +436,12 @@ sub push_email_address {
 	$email_address = $2;
     }
 
-    if ($email_usename && $email_name) {
-	push(@email_to,	format_email($email_name, $email_address));
-    } else {
-	push(@email_to, $email_address);
+    if ($email_maintainer) {
+	if ($email_usename && $email_name) {
+	    push(@email_to, format_email($email_name, $email_address));
+	} else {
+	    push(@email_to, $email_address);
+	}
     }
 }
 
-- 
1.6.3.1.10.g659a0.dirty

