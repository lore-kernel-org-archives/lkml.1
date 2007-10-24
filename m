Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbXJXQ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbXJXQ33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbXJXQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33341 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758006AbXJXQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:12 -0400
Date: Wed, 24 Oct 2007 18:23:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/power/disk.c: make code static
Message-ID: <20071024162342.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

resume_file[] and create_image() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/power/disk.c |    4 ++--
 kernel/power/swap.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 8b15f77..cce9b9e 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -26,7 +26,7 @@
 
 
 static int noresume = 0;
-char resume_file[256] = CONFIG_PM_STD_PARTITION;
+static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
@@ -145,7 +145,7 @@ static void platform_restore_cleanup(int platform_mode)
  *	reappears in this routine after a restore.
  */
 
-int create_image(int platform_mode)
+static int create_image(int platform_mode)
 {
 	int error;
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 917aba1..ef41440 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -28,8 +28,6 @@
 
 #include "power.h"
 
-extern char resume_file[];
-
 #define SWSUSP_SIG	"S1SUSPEND"
 
 struct swsusp_header {

