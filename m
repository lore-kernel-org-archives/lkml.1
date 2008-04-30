Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbYD3VQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbYD3VQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbYD3VQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:16:38 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:42297 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790AbYD3VQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:16:37 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 17:16:37 EDT
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: jclyXLBJ10ZHTmMMskdeEV9K+qamm4K24+0GzTHYHnheuzKtvddXf0g7srZHO6w=
Message-ID: <4818DEE5.6090405@hartkopp.net>
Date: Wed, 30 Apr 2008 23:04:37 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [PATCH] hrtimer: remove duplicate helper function
Content-Type: multipart/mixed;
 boundary="------------090300060303070403020302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090300060303070403020302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

from Oliver Hartkopp <oliver@hartkopp.net>

The helper function hrtimer_callback_running() is used in 
kernel/hrtimer.c as well as in the updated net/can/bcm.c which now 
supports hrtimers. Moving the helper function to hrtimer.h removes the 
duplicate definition in the C-files.

Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Thomas Gleixner <tglx@linutronix.de>

---

Hello Thomas,

as discussed on the OSADL workshop here is the removal of my duplicate 
definition of your helper function in net/can/bcm.c .

The patch applies fine on Linus' current tree for the 2.6.26 merge.

Thanks & best regards,
Oliver




--------------090300060303070403020302
Content-Type: text/plain;
 name="hrtimer_remove_duplicate_helper_function"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer_remove_duplicate_helper_function"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 31a4d65..6d93dce 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -316,6 +316,15 @@ static inline int hrtimer_is_queued(struct hrtimer *timer)
 		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
 }
 
+/*
+ * Helper function to check, whether the timer is running the callback
+ * function
+ */
+static inline int hrtimer_callback_running(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_CALLBACK;
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9af1d6a..421be5f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -154,15 +154,6 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 }
 
 /*
- * Helper function to check, whether the timer is running the callback
- * function
- */
-static inline int hrtimer_callback_running(struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_CALLBACK;
-}
-
-/*
  * Functions and macros which are different for UP/SMP systems are kept in a
  * single place
  */
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 74fd2d3..d9a3a9d 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -412,12 +412,6 @@ static void bcm_rx_changed(struct bcm_op *op, struct can_frame *data)
 	bcm_send_to_user(op, &head, data, 1);
 }
 
-/* TODO: move to linux/hrtimer.h */
-static inline int hrtimer_callback_running(struct hrtimer *timer)
-{
-        return timer->state & HRTIMER_STATE_CALLBACK;
-}
-
 /*
  * bcm_rx_update_and_send - process a detected relevant receive content change
  *                          1. update the last received data

--------------090300060303070403020302--
