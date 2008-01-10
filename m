Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYAJU1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYAJU1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYAJU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:27:28 -0500
Received: from ambient.dashsystems.com ([216.27.85.7]:34182 "EHLO
	kettle.ambient-hosting.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296AbYAJU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:27:27 -0500
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 15:27:27 EST
From: Andy Wingo <wingo@pobox.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] macintosh: fix fabrication of caplock key events
Date: Thu, 10 Jan 2008 15:06:51 +0100
Message-ID: <87prw9n5ac.fsf@pobox.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user has turned on the "restore_caplock_events" parameter, the
code mangles the capslock events correctly, then erroneously ignores
those events. Fix logic to allow correct fallthrough.

Signed-off-by: Andy Wingo <wingo@pobox.com>
---

diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index 883da72..ef4c117 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -322,8 +322,9 @@ adbhid_input_keycode(int id, int scancode, int repeat)
 			input_sync(ahid->input);
 			input_report_key(ahid->input, KEY_CAPSLOCK, 0);
 			input_sync(ahid->input);
+			return;
 		}
-		return;
+		break;
 #ifdef CONFIG_PPC_PMAC
 	case ADB_KEY_POWER_OLD: /* Power key on PBook 3400 needs remapping */
 		switch(pmac_call_feature(PMAC_FTR_GET_MB_INFO,
