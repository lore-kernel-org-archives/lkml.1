Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZGMVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZGMVdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZGMVdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:33:08 -0400
Received: from server1.wserver.cz ([82.113.45.157]:52902 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbZGMVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:33:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] toshiba_acpi: return on a fail path
Date: Mon, 13 Jul 2009 23:25:03 +0200
Message-Id: <1247520303-32070-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return from bt_rfkill_poll when hci_get_radio_state fails.

value is invalid in that case and should not be assigned to the
rfkill state.

This also fixes a double unlock bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 81d31ea..51c0a8b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -335,6 +335,7 @@ static void bt_rfkill_poll(struct rfkill *rfkill, void *data)
 	if (hci_result != HCI_SUCCESS) {
 		/* Can't do anything useful */
 		mutex_unlock(&dev->mutex);
+		return;
 	}
 
 	new_rfk_state = value;
-- 
1.6.3.2

