Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0BHUNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:13:18 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:53856 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0BHUNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:11 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 27/41] CAPI: Issue synchronous hangup on capincci_free_minor
Date: Mon,  8 Feb 2010 21:12:31 +0100
Message-Id: <7604ecd5c725f0fa52b73a6aadda3d5e19d54433.1265659936.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1/wI0aENZu/6rrPqnZz3XY454qMPe4AM8esChDw
	tRTRz4crznYknJLFHiXUaCle+TuU+PKIjfBisRrSJMH8xF4M6b
	B+uZbW0Y4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capincci_free and, thus, capincci_free_minor runs in process context, so
we can issue the hangup of the associated TTY synchronously.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index acc811b..b382ede 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -351,7 +351,7 @@ static void capincci_free_minor(struct capincci *np)
 #ifdef _DEBUG_REFCOUNT
 			printk(KERN_DEBUG "reset mp->nccip\n");
 #endif
-			tty_hangup(tty);
+			tty_vhangup(tty);
 			tty_kref_put(tty);
 		}
 
-- 
1.6.0.2

