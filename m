Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYIWHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYIWHgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYIWHgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:36:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:40528 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYIWHgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aJ8hOfaZCsM8aoRLDfZR34uYXgSraiSoPxpPOG/BG6o+e5Jn9DC6j2RlF2zhkmghSt
         8ZQU/N/VEPddtQ4N/Meit6JsRbMTYgJLFQlgr1kHRmrdoW4UmRZAXpdPXr3TkHqrjLtu
         Y/kMCufTXJjkidgALU5za10lRXUfv1OmKSzaQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: x86: fix macro with bad_bios_dmi_table
Date: Tue, 23 Sep 2008 00:35:33 -0700
Message-Id: <1222155333-18247-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need one blank tail.

fix the crash on ingo's test box.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a9998cb..3d677b5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -760,8 +760,8 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
 		},
 	},
-	{}
 #endif
+	{}
 };
 
 /*
