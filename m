Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0CIT3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:29:15 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:57404 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0CIT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ldB9zTMEDgMG9nJdiS3JlfihJKfwysyfeziTtydFoR9omNl6uBTEoLdjAhsmkVCiV6
         cOlyAL3paLCJkcdb6/TgyatfTZi0E1JHAot8cEvzN8Qina9sEa9LrThXVz76Z6o3ySjW
         RO1ntukTq7E02CegiurAKzhf/SDWC6LnnE86M=
From: Nick Savage <nagaten@gmail.com>
To: benh@kernel.crashing.org, fthain@telegraphics.com.au,
       grant.likely@secretlab.ca, geert@linux-m68k.org, monstr@monstr.eu
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Nick Savage <nagaten@gmail.com>
Subject: [PATCH] Staging: macintosh: fix whitespace and style in adb.c This is a patch to the adb.c file, fixing the formatting of braces and tabs. Signed-off-by: Nick Savage
Date: Tue,  9 Mar 2010 14:28:35 -0500
Message-Id: <1268162915-12767-1-git-send-email-nagaten@gmail.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/macintosh/adb.c |   71 +++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 1c4ee6e..89891bb 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -115,27 +115,27 @@ static DEFINE_RWLOCK(adb_handler_lock);
 #if 0
 static void printADBreply(struct adb_request *req)
 {
-        int i;
+	int i;
 
-        printk("adb reply (%d)", req->reply_len);
-        for(i = 0; i < req->reply_len; i++)
-                printk(" %x", req->reply[i]);
-        printk("\n");
+	printk("adb reply (%d)", req->reply_len);
+	for (i = 0; i < req->reply_len; i++)
+		printk(" %x", req->reply[i]);
+	printk("\n");
 
 }
 #endif
 
 static int adb_scan_bus(void)
 {
-	int i, highFree=0, noMovement;
+	int i, highFree = 0, noMovement;
 	int devmask = 0;
 	struct adb_request req;
-	
+
 	/* assumes adb_handler[] is all zeroes at this point */
 	for (i = 1; i < 16; i++) {
 		/* see if there is anything at address i */
 		adb_request(&req, NULL, ADBREQ_SYNC | ADBREQ_REPLY, 1,
-                            (i << 4) | 0xf);
+			(i << 4) | 0xf);
 		if (req.reply_len > 1)
 			/* one or more devices at this address */
 			adb_handler[i].original_address = i;
@@ -161,7 +161,7 @@ static int adb_scan_bus(void)
 			 * this only moves one device.
 			 */
 			adb_request(&req, NULL, ADBREQ_SYNC, 3,
-				    (i<< 4) | 0xb, (highFree | 0x60), 0xfe);
+				    (i << 4) | 0xb, (highFree | 0x60), 0xfe);
 			/*
 			 * See if anybody actually moved. This is suggested
 			 * by HW TechNote 01:
@@ -170,7 +170,8 @@ static int adb_scan_bus(void)
 			 */
 			adb_request(&req, NULL, ADBREQ_SYNC | ADBREQ_REPLY, 1,
 				    (highFree << 4) | 0xf);
-			if (req.reply_len <= 1) continue;
+			if (req.reply_len <= 1)
+				continue;
 			/*
 			 * Test whether there are any device(s) left
 			 * at address i.
@@ -193,8 +194,7 @@ static int adb_scan_bus(void)
 					break;
 
 				noMovement = 0;
-			}
-			else {
+			} else {
 				/*
 				 * No devices left at address i; move the
 				 * one(s) we moved to `highFree' back to i.
@@ -203,7 +203,7 @@ static int adb_scan_bus(void)
 					    (highFree << 4) | 0xb,
 					    (i | 0x60), 0xfe);
 			}
-		}	
+		}
 	}
 
 	/* Now fill in the handler_id field of the adb_handler entries. */
@@ -307,7 +307,7 @@ static int __init adb_init(void)
 	if (adb_inited)
 		return 0;
 	adb_inited = 1;
-		
+
 	adb_controller = NULL;
 
 	i = 0;
@@ -341,10 +341,10 @@ static int
 do_adb_reset_bus(void)
 {
 	int ret;
-	
+
 	if (adb_controller == NULL)
 		return -ENXIO;
-		
+
 	if (adb_controller->autopoll)
 		adb_controller->autopoll(0);
 
@@ -381,14 +381,14 @@ do_adb_reset_bus(void)
 
 	blocking_notifier_call_chain(&adb_client_list,
 		ADB_MSG_POST_RESET, NULL);
-	
+
 	return ret;
 }
 
 void
 adb_poll(void)
 {
-	if ((adb_controller == NULL)||(adb_controller->poll == NULL))
+	if ((adb_controller == NULL) || (adb_controller->poll == NULL))
 		return;
 	adb_controller->poll();
 }
@@ -459,7 +459,7 @@ adb_register(int default_id, int handler_id, struct adb_ids *ids,
 	ids->nids = 0;
 	for (i = 1; i < 16; i++) {
 		if ((adb_handler[i].original_address == default_id) &&
-		    (!handler_id || (handler_id == adb_handler[i].handler_id) || 
+		    (!handler_id || (handler_id == adb_handler[i].handler_id) ||
 		    try_handler_change(i, handler_id))) {
 			if (adb_handler[i].handler != 0) {
 				printk(KERN_ERR
@@ -485,7 +485,7 @@ adb_unregister(int index)
 	mutex_lock(&adb_handler_mutex);
 	write_lock_irq(&adb_handler_lock);
 	if (adb_handler[index].handler) {
-		while(adb_handler[index].busy) {
+		while (adb_handler[index].busy) {
 			write_unlock_irq(&adb_handler_lock);
 			yield();
 			write_lock_irq(&adb_handler_lock);
@@ -504,7 +504,7 @@ adb_input(unsigned char *buf, int nb, int autopoll)
 	int i, id;
 	static int dump_adb_input = 0;
 	unsigned long flags;
-	
+
 	void (*handler)(unsigned char *, int, int);
 
 	/* We skip keystrokes and mouse moves when the sleep process
@@ -512,7 +512,7 @@ adb_input(unsigned char *buf, int nb, int autopoll)
 	 */
 	if (adb_got_sleep)
 		return;
-		
+
 	id = buf[0] >> 4;
 	if (dump_adb_input) {
 		printk(KERN_INFO "adb packet: ");
@@ -530,7 +530,7 @@ adb_input(unsigned char *buf, int nb, int autopoll)
 		wmb();
 		adb_handler[id].busy = 0;
 	}
-		
+
 }
 
 /* Try to change handler to new_id. Will return 1 if successful. */
@@ -539,15 +539,15 @@ static int try_handler_change(int address, int new_id)
 	struct adb_request req;
 
 	if (adb_handler[address].handler_id == new_id)
-	    return 1;
+		return 1;
 	adb_request(&req, NULL, ADBREQ_SYNC, 3,
 	    ADB_WRITEREG(address, 3), address | 0x20, new_id);
 	adb_request(&req, NULL, ADBREQ_SYNC | ADBREQ_REPLY, 1,
 	    ADB_READREG(address, 3));
 	if (req.reply_len < 2)
-	    return 0;
+		return 0;
 	if (req.reply[2] != new_id)
-	    return 0;
+		return 0;
 	adb_handler[address].handler_id = req.reply[2];
 
 	return 1;
@@ -586,7 +586,7 @@ struct adbdev_state {
 	spinlock_t	lock;
 	atomic_t	n_pending;
 	struct adb_request *completed;
-  	wait_queue_head_t wait_queue;
+	wait_queue_head_t wait_queue;
 	int		inuse;
 };
 
@@ -624,8 +624,7 @@ do_adb_query(struct adb_request *req)
 {
 	int	ret = -EINVAL;
 
-	switch(req->data[1])
-	{
+	switch (req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
 		if (req->nbytes < 3)
 			break;
@@ -697,7 +696,7 @@ static ssize_t adb_read(struct file *file, char __user *buf,
 	int ret = 0;
 	struct adbdev_state *state = file->private_data;
 	struct adb_request *req;
-	wait_queue_t wait = __WAITQUEUE_INITIALIZER(wait,current);
+	wait_queue_t wait = __WAITQUEUE_INITIALIZER(wait, current);
 	unsigned long flags;
 
 	if (count < 2)
@@ -720,7 +719,7 @@ static ssize_t adb_read(struct file *file, char __user *buf,
 			ret = -EIO;
 		if (req != NULL || ret != 0)
 			break;
-		
+
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
 			break;
@@ -737,7 +736,7 @@ static ssize_t adb_read(struct file *file, char __user *buf,
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&state->wait_queue, &wait);
 	spin_unlock_irqrestore(&state->lock, flags);
-	
+
 	if (ret)
 		return ret;
 
@@ -774,7 +773,7 @@ static ssize_t adb_write(struct file *file, const char __user *buf,
 	req->done = adb_write_done;
 	req->arg = (void *) state;
 	req->complete = 0;
-	
+
 	ret = -EFAULT;
 	if (copy_from_user(req->data, buf, count))
 		goto out;
@@ -794,15 +793,15 @@ static ssize_t adb_write(struct file *file, const char __user *buf,
 	}
 	/* Special case for ADB_BUSRESET request, all others are sent to
 	   the controller */
-	else if ((req->data[0] == ADB_PACKET)&&(count > 1)
-		&&(req->data[1] == ADB_BUSRESET)) {
+	else if ((req->data[0] == ADB_PACKET) && (count > 1)
+		&& (req->data[1] == ADB_BUSRESET)) {
 		ret = do_adb_reset_bus();
 		up(&adb_probe_mutex);
 		atomic_dec(&state->n_pending);
 		if (ret == 0)
 			ret = count;
 		goto out;
-	} else {	
+	} else {
 		req->reply_expected = ((req->data[1] & 0xc) == 0xc);
 		if (adb_controller && adb_controller->send_request)
 			ret = adb_controller->send_request(req, 0);
-- 
1.7.0.1

