Return-Path: <linux-kernel-owner+w=401wt.eu-S932892AbYDUNcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbYDUNcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760019AbYDUNTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYDUNTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=s6H2nEa9V33W7O1xU4tULhE0sH+391YtpiATqXjurjcbmzrLeplNowr7D/PXWEGngGturs1fUbtB3AogfHYZyw5eVYP7sg4nZZ/A93X0r//fLja8vZEvQ6cJx/JkJPRbjNAv8MSvguxe/4U29Pczg54AZIjzlaZoaZ0gLZ2aKSA=
Message-Id: <2fd746d97fa0452173e06ffd9d0bb376d97bef0b.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 17 Apr 2008 09:28:25 -0400
Subject: [PATCH 33/37] Input: drivers/char/keyboard.c - use time_after
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Julia Lawall <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/char/keyboard.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 59608e3..45806d2 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -42,6 +42,7 @@
 #include <linux/input.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
+#include <linux/jiffies.h>
 
 extern void ctrl_alt_del(void);
 
@@ -928,7 +929,8 @@ static void k_brl(struct vc_data *vc, unsigned char value, char up_flag)
 	if (up_flag) {
 		if (brl_timeout) {
 			if (!committing ||
-			    jiffies - releasestart > (brl_timeout * HZ) / 1000) {
+			    time_after(jiffies,
+				       releasestart + msecs_to_jiffies(brl_timeout))) {
 				committing = pressed;
 				releasestart = jiffies;
 			}
-- 
1.5.5.rc2.6.gf58d


