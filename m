Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZDQRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZDQRvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759536AbZDQRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:51:08 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:41773 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759045AbZDQRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:51:08 -0400
X-Greylist: delayed 1968 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 13:51:07 EDT
From: Dan Smith <danms@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com
Subject: [PATCH] Make new_utsname fields use the proper length constant
Date: Fri, 17 Apr 2009 10:18:16 -0700
Message-Id: <1239988696-18140-1-git-send-email-danms@us.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The members of the new_utsname structure are defined with magic numbers
that *should* correspond to the constant __NEW_UTS_LEN+1.  Everywhere else,
code assumes this and uses the constant, so this patch makes the structure
match.

Originally suggested by Serge here:

https://lists.linux-foundation.org/pipermail/containers/2009-March/016258.html

Signed-off-by: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.linux-foundation.org
Cc: akpm@linux-foundation.org
Cc: serue@us.ibm.com
---
 include/linux/utsname.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 1123267..3656b30 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -22,12 +22,12 @@ struct old_utsname {
 };
 
 struct new_utsname {
-	char sysname[65];
-	char nodename[65];
-	char release[65];
-	char version[65];
-	char machine[65];
-	char domainname[65];
+	char sysname[__NEW_UTS_LEN + 1];
+	char nodename[__NEW_UTS_LEN + 1];
+	char release[__NEW_UTS_LEN + 1];
+	char version[__NEW_UTS_LEN + 1];
+	char machine[__NEW_UTS_LEN + 1];
+	char domainname[__NEW_UTS_LEN + 1];
 };
 
 #ifdef __KERNEL__
-- 
1.5.6.3

