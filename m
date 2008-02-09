Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYBIEp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYBIEp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 23:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYBIEpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 23:45:17 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:35494 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYBIEpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 23:45:15 -0500
To: Dmitry Torokhov <dtor@mail.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: i8042 - Fix warning on non-x86 builds
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
Date: Fri, 08 Feb 2008 20:45:11 -0800
Message-ID: <ada4pci20x4.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2008 04:45:12.0054 (UTC) FILETIME=[8E273960:01C86AD6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c18bab80 ("Input: i8042 - non-x86 build fix") introduced the
following warning on non-x86 builds:

    drivers/input/serio/i8042.c: In function 'i8042_probe':
    drivers/input/serio/i8042.c:1154: warning: unused variable 'param'

Fix this by moving the parameter variable declaration into the #ifdef too.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 2763394..65a74cf 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1151,7 +1151,6 @@ static int __devinit i8042_setup_kbd(void)
 static int __devinit i8042_probe(struct platform_device *dev)
 {
 	int error;
-	char param;
 
 	error = i8042_controller_selftest();
 	if (error)
@@ -1174,7 +1173,7 @@ static int __devinit i8042_probe(struct platform_device *dev)
 	}
 #ifdef CONFIG_X86
 	if (i8042_dritek) {
-		param = 0x90;
+		char param = 0x90;
 		error = i8042_command(&param, 0x1059);
 		if (error)
 			goto out_fail;
