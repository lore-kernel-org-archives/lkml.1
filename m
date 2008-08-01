Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYHAMMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYHAMMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYHAMMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:12:13 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:33386 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYHAMMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:12:12 -0400
Subject: [PATCH] hrtimer: reorder struct hrtimer to save 8 bytes on 64 bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: tglx@linutronix.de
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:11:49 +0100
Message-Id: <1217592709.2953.7.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct hrtimer to save 8 bytes on 64 bit builds when
CONFIG_TIMER_STATS selected.
(also removes 8 bytes from signal_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.27-rc1.
compiled & tested on AMD64 desktop machine.

richard


 include/linux/hrtimer.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6d93dce..7d1dcf9 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -115,12 +115,12 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
-	enum hrtimer_cb_mode		cb_mode;
 	struct list_head		cb_entry;
+	enum hrtimer_cb_mode		cb_mode;
 #ifdef CONFIG_TIMER_STATS
+	int				start_pid;
 	void				*start_site;
 	char				start_comm[16];
-	int				start_pid;
 #endif
 };
 
-- 
1.5.5.1



