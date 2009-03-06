Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZCFGos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZCFGos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZCFGlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:05 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50912 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZCFGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:57 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883657"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 12/18] Blackfin Serial Driver: fix building when debug is enabled but serial console is disabled
Date: Fri,  6 Mar 2009 14:42:54 +0800
Message-Id: <1236321780-28718-13-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 5193d62..b89861d 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1256,8 +1256,10 @@ void bfin_serial_debug(const char *fmt, ...)
 	char buf[128];
 	va_list ap;
 
+#ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	if (bfin_serial_console.index < 0)
 		return;		/* Too early. */
+#endif
 
 	va_start(ap, fmt);
 	vsprintf(buf, fmt, ap);
-- 
1.5.6.3
