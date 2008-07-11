Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYGKOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYGKOuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYGKOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:49:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:21544 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYGKOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:49:57 -0400
X-IronPort-AV: E=Sophos;i="4.30,345,1212364800"; 
   d="scan'208";a="984440"
Message-ID: <4877732A.5030106@eu.citrix.com>
Date: Fri, 11 Jul 2008 15:50:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] vt: do not update when the console is blanked
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2008 14:49:55.0437 (UTC) FILETIME=[61EFD9D0:01C8E365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
vt.c DO_UPDATE macro checks if the console is visible but doesn't check if
the console is blanked.
In fact updating fbcon while the console is blanked is not only unnecessary
but can even cause screen corruption.
Therefore I am adding a simple check on console_blanked in DO_UPDATE.

Signed-off-by: stefano.stabellini@eu.citrix.com

---

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 935f1c2..8d4bd3c 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -261,7 +261,7 @@ static void notify_update(struct vc_data *vc)
 #ifdef VT_BUF_VRAM_ONLY
 #define DO_UPDATE(vc)	0
 #else
-#define DO_UPDATE(vc)	CON_IS_VISIBLE(vc)
+#define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !console_blanked)
 #endif
 
 static inline unsigned short *screenpos(struct vc_data *vc, int offset, int viewed)

