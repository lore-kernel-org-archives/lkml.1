Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZCRWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZCRWA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761354AbZCRWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:00:08 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:42962 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761338AbZCRWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:00:05 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 18:00:05 EDT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/3] Restrict definition of a variable in kernel/sysctl.c
Date: Wed, 18 Mar 2009 23:49:25 +0200
Message-Id: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable "one" in kernel/sysctl.c is used only if either CONFIG_HIGHMEM,
or CONFIG_DETECT_SOFTLOCKUP are defined (or both). Hence, if neither option
is enabled, the following error is produced:

  CC      kernel/sysctl.o
kernel/sysctl.c:99: warning: 'one' defined but not used

This patch fixes the warning by moving the variable definition under an
appropriate preprocessor construct.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 kernel/sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..f172d9f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -95,12 +95,15 @@ static int sixty = 60;
 static int neg_one = -1;
 #endif
 
+#if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+static int one = 1;
+#endif
+
 #if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
 static int two = 2;
 #endif
 
 static int zero;
-static int one = 1;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
-- 
1.5.6.3

