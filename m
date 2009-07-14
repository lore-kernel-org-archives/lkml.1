Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZGNQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZGNQGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZGNQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:06:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42233 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZGNQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:06:15 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, rpurdie@rpsys.net, lenb@kernel.org,
       rui.zhang@intel.com, corentincj@iksaif.net,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] eeepc-laptop: Update the backlight state when we change brightness
Date: Tue, 14 Jul 2009 17:06:04 +0100
Message-Id: <1247587564-27737-3-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247587564-27737-2-git-send-email-mjg@redhat.com>
References: <1247587564-27737-1-git-send-email-mjg@redhat.com>
 <1247587564-27737-2-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trigger a status update when the user hits a brightness key, allowing
userspace to present appropriate UI.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/eeepc-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index ec560f1..fde86b3 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -641,7 +641,7 @@ static int notify_brn(void)
 	struct backlight_device *bd = eeepc_backlight_device;
 	if (bd) {
 		int old = bd->props.brightness;
-		bd->props.brightness = read_brightness(bd);
+		backlight_force_update(bd, BACKLIGHT_UPDATE_HOTKEY);
 		return old;
 	}
 	return -1;
-- 
1.6.2.5

