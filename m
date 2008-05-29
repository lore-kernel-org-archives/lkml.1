Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYE2R1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYE2R1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYE2R1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:27:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYE2R1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:27:23 -0400
From: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2 v3] Use structs instead of hardcoded offsets in x86 boot decompressor.
Date: Thu, 29 May 2008 13:27:11 -0400
Message-Id: <1212082032-6167-1-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor cleanup, making it easier to access the command line in
the following "Honor quiet in decompressor" patch.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>

---

Updated this one to be less intrusive; we just re-#define RM_SCREEN_INFO to
access the boot_params struct instead of using the hard-coded offset.

 arch/x86/boot/compressed/misc.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 90456ce..102b68e 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/boot.h>
+#include <asm/bootparam.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -187,13 +188,8 @@ static void gzip_release(void **);
 /*
  * This is set up by the setup-routine at boot-time
  */
-static unsigned char *real_mode; /* Pointer to real-mode data */
-
-#define RM_EXT_MEM_K   (*(unsigned short *)(real_mode + 0x2))
-#ifndef STANDARD_MEMORY_BIOS_CALL
-#define RM_ALT_MEM_K   (*(unsigned long *)(real_mode + 0x1e0))
-#endif
-#define RM_SCREEN_INFO (*(struct screen_info *)(real_mode+0))
+static struct boot_params *real_mode;		/* Pointer to real-mode data */
+#define RM_SCREEN_INFO (real_mode->screen_info)
 
 extern unsigned char input_data[];
 extern int input_len;
-- 
1.5.4.5

