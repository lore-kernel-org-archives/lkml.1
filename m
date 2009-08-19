Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZHSORq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZHSORq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZHSORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:17:32 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:31616 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbZHSORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:17:31 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mjg@redhat.com
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 5/5] dell-laptop: poll the rfkill hard-block
Date: Wed, 19 Aug 2009 15:06:51 +0100
Message-Id: <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4A8C0623.8030808@tuffmail.co.uk>
References: <4A8C0623.8030808@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is controlled by a hardware switch, so we should poll it in order
to pick up changes.  (There does not appear to be an interrupt or any
other notification mechanism).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/dell-laptop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 250c4b1..349cf12 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -195,7 +195,7 @@ static int dell_rfkill_set(void *data, bool blocked)
 	return 0;
 }
 
-static void dell_rfkill_query(struct rfkill *rfkill, void *data)
+static void dell_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct calling_interface_buffer buffer;
 	int status;
@@ -211,7 +211,7 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 
 static const struct rfkill_ops dell_rfkill_ops = {
 	.set_block = dell_rfkill_set,
-	.query = dell_rfkill_query,
+	.poll = dell_rfkill_poll,
 };
 
 static int __init dell_setup_rfkill(void)
-- 
1.6.3.2

