Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZAaD2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZAaD2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbZAaD1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:27:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:54304 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbZAaD1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:27:46 -0500
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: swetland@google.com, pavel@ucw.cz,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 1/2] PM: Wait for console in resume.
Date: Fri, 30 Jan 2009 19:27:38 -0800
Message-Id: <1233372459-6434-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128193047.GA1222@ucw.cz>
References: <20090128193047.GA1222@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids later waking up to a blinking cursor if the device
woke up and returned to sleep before the console switch happened.

Signed-off-by: Brian Swetland <swetland@google.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 kernel/power/console.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/power/console.c b/kernel/power/console.c
index b8628be..a3961b2 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -78,6 +78,12 @@ void pm_restore_console(void)
 	}
 	set_console(orig_fgconsole);
 	release_console_sem();
+
+	if (vt_waitactive(orig_fgconsole)) {
+		pr_debug("Resume: Can't switch VCs.");
+		return;
+	}
+
 	kmsg_redirect = orig_kmsg;
 }
 #endif
-- 
1.6.1

