Return-Path: <linux-kernel-owner+w=401wt.eu-S935343AbYDNSxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935343AbYDNSxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934846AbYDNSst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:48:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43995 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780AbYDNSss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:48:48 -0400
Date: Mon, 14 Apr 2008 21:41:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] video/pvrusb2/pvrusb2-hdw.c cleanups
Message-ID: <20080414184153.GZ6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global function static:
  - pvr2_hdw_set_cur_freq()
- #if 0 the following unused global functions:
  - pvr2_hdw_get_state_name()
  - pvr2_hdw_get_debug_info_unlocked()
  - pvr2_hdw_get_debug_info_locked()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    6 +++++-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h |    3 ---
 2 files changed, 5 insertions(+), 4 deletions(-)

5446a1c0b050259bf276f1d365ca151afa276887 diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index d6955fa..77c3c2d 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -983,7 +983,7 @@ unsigned long pvr2_hdw_get_cur_freq(struct pvr2_hdw *hdw)
 
 /* Set the currently tuned frequency and account for all possible
    driver-core side effects of this action. */
-void pvr2_hdw_set_cur_freq(struct pvr2_hdw *hdw,unsigned long val)
+static void pvr2_hdw_set_cur_freq(struct pvr2_hdw *hdw,unsigned long val)
 {
 	if (hdw->input_val == PVR2_CVAL_INPUT_RADIO) {
 		if (hdw->freqSelector) {
@@ -1365,11 +1365,13 @@ int pvr2_hdw_untrip(struct pvr2_hdw *hdw)
 }
 
 
+#if 0
 const char *pvr2_hdw_get_state_name(unsigned int id)
 {
 	if (id >= ARRAY_SIZE(pvr2_state_names)) return NULL;
 	return pvr2_state_names[id];
 }
+#endif  /*  0  */
 
 
 int pvr2_hdw_get_streaming(struct pvr2_hdw *hdw)
@@ -3656,6 +3658,7 @@ static void pvr2_hdw_state_sched(struct pvr2_hdw *hdw)
 	queue_work(hdw->workqueue,&hdw->workpoll);
 }
 
+#if 0
 
 void pvr2_hdw_get_debug_info_unlocked(const struct pvr2_hdw *hdw,
 				      struct pvr2_hdw_debug_info *ptr)
@@ -3697,6 +3700,7 @@ void pvr2_hdw_get_debug_info_locked(struct pvr2_hdw *hdw,
 	} while(0); LOCK_GIVE(hdw->ctl_lock);
 }
 
+#endif  /*  0  */
 
 int pvr2_hdw_gpio_get_dir(struct pvr2_hdw *hdw,u32 *dp)
 {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.h b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
index 3ad7a13..1b4e5e3 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
@@ -90,9 +90,6 @@ enum pvr2_v4l_type {
 /* Translate configuration enum to a string label */
 const char *pvr2_config_get_name(enum pvr2_config);
 
-/* Translate a master state enum to a string label */
-const char *pvr2_hdw_get_state_name(unsigned int);
-
 struct pvr2_hdw;
 
 /* Create and return a structure for interacting with the underlying

