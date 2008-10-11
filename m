Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYJKGo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYJKGo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYJKGhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:38 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbYJKGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:35 -0400
Date: Sat, 11 Oct 2008 02:36:18 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 58/85] ACPI: toshiba_acpi.c fix sparse signedness mismatch
 warnings
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Message-id: <9e113e0014204bfb44a2baa29b2a141ede41b074.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

set_bit expects unsigned int, and we start with a u32 anyway.
drivers/acpi/toshiba_acpi.c:397:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:397:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:397:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:399:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:399:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:399:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:401:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:401:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:401:14:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/toshiba_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 0a43c8e..4172d29 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -392,7 +392,7 @@ static unsigned long write_video(const char *buffer, unsigned long count)
 
 	hci_read1(HCI_VIDEO_OUT, &video_out, &hci_result);
 	if (hci_result == HCI_SUCCESS) {
-		int new_video_out = video_out;
+		unsigned int new_video_out = video_out;
 		if (lcd_out != -1)
 			_set_bit(&new_video_out, HCI_VIDEO_OUT_LCD, lcd_out);
 		if (crt_out != -1)
-- 
1.5.5.1

