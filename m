Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZKWBls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZKWBls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKWBlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:41:47 -0500
Received: from cust-66-114-178-157.t6broadband.com ([66.114.178.157]:49589
	"HELO bcdb.mspradling.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1752571AbZKWBlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:41:47 -0500
X-Greylist: delayed 3694 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 20:41:46 EST
From: mike@mspradling.com
To: davem@davemloft.net, hugh.dickins@ticali.co.uk, linville@tuxdriver.com,
       johannes@sipsolutions.net, mike@mspradling.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fixed bug in Wireless Extension Code (CONFIG_WEXT_CORE).
Date: Sun, 22 Nov 2009 19:36:42 -0500
Message-Id: <1258936602-6110-1-git-send-email-mike@mspradling.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Spradling <mike@mspradling.com>

When CONFIG_WEXT_CORE is not enabled and CONFIG_WEXT_PRIV is enabled
there currently is a few build errors.  This is because several
functions call function call_commit_handler which is currently only
defined when CONFIG_WEXT_CORE is enabled.

Signed-off-by: Michael Spradling <mike@mspradling.com>
---
 include/net/wext.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/wext.h b/include/net/wext.h
index 4f6e742..773c8c6 100644
--- a/include/net/wext.h
+++ b/include/net/wext.h
@@ -24,6 +24,10 @@ static inline int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
 {
 	return -EINVAL;
 }
+static inline int call_commit_handler(struct net_device *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #ifdef CONFIG_WEXT_PROC
-- 
1.6.5.2


