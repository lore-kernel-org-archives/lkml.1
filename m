Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZAYNN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZAYNN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZAYNNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:13:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbZAYNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:13:49 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] fix compilation error in ide code
Date: Sun, 25 Jan 2009 14:13:44 +0100
Message-Id: <1232889227-20887-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090125123023.GA12248@pengutronix.de>
References: <20090125123023.GA12248@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 97b45b274f48aeec changed a local_save_flags to
local_save_flags_nort which is not defined and not used anywhere else.
Change this back to local_save_flags as there is no reason not to read
the flags in RT code.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ide.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index dc5ac49..a3cf9c1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1622,7 +1622,7 @@ extern struct mutex ide_cfg_mtx;
 
 #define local_irq_set(flags)			\
 	do {					\
-		local_save_flags_nort((flags)); \
+		local_save_flags((flags)); \
 		local_irq_enable_in_hardirq();	\
 	} while (0)
 
-- 
1.5.6.5

