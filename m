Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXDNHae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXDNHae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXDNHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:30:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:50206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbXDNHad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=bwsEwMPjDFESBlTaROyNRsC84H6HlB6v41deIJ8MhkQzFUUFFRF4uFIU8ZNtXQo8Epx/CbdmIHDsrptNn8qvciYkxgEpDTnZgJ3f50CabuzOjVLLVxrIDVvcqPPKGOv/HMYxB8INZw3Ii3v72Rxw9k6965QBZCRmX6xiQbnFg8M=
Date: Sat, 14 Apr 2007 13:02:27 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [KJ][PATCH]use set_current_state in drivers/char
Message-ID: <20070414073227.GA14084@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use set_current_state(TASK_*) instead of current->state = TASK_*,

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 amiserial.c |    4 ++--
 cyclades.c  |    4 ++--
 epca.c      |    2 +-
 genrtc.c    |    2 +-
 mxser.c     |    2 +-
 mxser_new.c |    2 +-
 n_r3964.c   |    4 ++--
 riscom8.c   |    2 +-
 rocket.c    |    4 ++--
 rtc.c       |    2 +-
 selection.c |    2 +-
 serial167.c |    2 +-
 vt_ioctl.c  |    2 +-
 13 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 0e2b72f..ccd7442 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1574,7 +1574,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
@@ -1700,7 +1700,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 		schedule();
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (extra_count)
 		state->count++;
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 16dc5d1..73ccaa7 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2446,7 +2446,7 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 		base_addr = cinfo->base_addr;
 		firm_id = base_addr + ID_ADDRESS;
 		if (!ISZLOADED(*cinfo)) {
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&info->open_wait, &wait);
 			return -EINVAL;
 		}
@@ -2499,7 +2499,7 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 			schedule();
 		}
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
 		info->count++;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index de5be30..0822167 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -949,7 +949,7 @@ static int block_til_ready(struct tty_struct *tty,
 
 	} /* End forever while  */
 
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&ch->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		ch->count++;
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 23b25ad..f2a3890 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -207,7 +207,7 @@ static ssize_t gen_rtc_read(struct file *file, char __user *buf,
 			sizeof(unsigned long);
 	}
  out:
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&gen_rtc_wait, &wait);
 
 	return retval;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index a61fb6d..5a5df94 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1370,7 +1370,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file, unsigned int c
 				}
 				cprev = cnow;
 			}
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&info->delta_msr_wait, &wait);
 			break;
 		}
diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 9af07e4..57e413e 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -1790,7 +1790,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 			}
 			cprev = cnow;
 		}
-		current->state = TASK_RUNNING;
+		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&info->delta_msr_wait, &wait);
 		break;
 	}
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 65f2d3a..616c7c0 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1088,13 +1088,13 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 			/* block until there is a message: */
 			add_wait_queue(&pInfo->read_wait, &wait);
 repeat:
-			current->state = TASK_INTERRUPTIBLE;
+			set_current_state(TASK_INTERRUPTIBLE);
 			pMsg = remove_msg(pInfo, pClient);
 			if (!pMsg && !signal_pending(current)) {
 				schedule();
 				goto repeat;
 			}
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&pInfo->read_wait, &wait);
 		}
 
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 7014525..8f47af8 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -980,7 +980,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 		schedule();
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		port->count++;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 76357c8..8d8bd27 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -947,7 +947,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 #endif
 		schedule();	/*  Don't hold spinlock here, will hang PC */
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1602,7 +1602,7 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 		if (signal_pending(current))
 			break;
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index c7dac9b..6acd14a 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -388,7 +388,7 @@ static ssize_t rtc_read(struct file *file, char __user *buf,
 	if (!retval)
 		retval = count;
  out:
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&rtc_wait, &wait);
 
 	return retval;
diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index 74cff83..d4168e3 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -299,7 +299,7 @@ int paste_selection(struct tty_struct *tty)
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 
 	tty_ldisc_deref(ld);
 	return 0;
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 5fd314a..7ac6d51 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1892,7 +1892,7 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 #endif
 		    schedule();
 	}
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
 		info->count++;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c9f2dd6..e2dae0d 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1061,7 +1061,7 @@ int vt_waitactive(int vt)
 		schedule();
 	}
 	remove_wait_queue(&vt_activate_queue, &wait);
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	return retval;
 }
 
-- 
Milind Arun Choudhary
