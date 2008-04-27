Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbYD0Bz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbYD0Bz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYD0BzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:55:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:10790 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYD0BzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XTkhof1PbFn94Ghegy8pz2jul5BqF37tLeQSowgdVA/FfNqtCAUljhD+7yM8eoe0vd6pJiLqbmO9SfU7vkf/NQ/0bL/pya5UaHKraORTwGSzyiHs/GwqHxghvC2yKjk+X0uinr/GQREBd/WBoMF4NrTxIjVnN+zvI3qICG8om+A=
Subject: [PATCH] trivial: do-while is not a compound statement
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 18:55:12 -0700
Message-Id: <1209261312.14173.38.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
More of an RFC...but it is trivial if you want to apply it, this is a
rollup of all the current places hit in an X86-32 allyesconfig.

 drivers/i2c/busses/i2c-ali1563.c |    8 ++++----
 drivers/media/video/ov511.c      |   12 ++++++------
 drivers/net/atp.c                |    8 ++++----
 drivers/net/eepro100.c           |    4 ++--
 drivers/net/plip.c               |   16 ++++++++--------
 drivers/net/starfire.c           |    4 ++--
 drivers/net/tulip/de2104x.c      |    4 ++--
 drivers/net/tulip/tulip_core.c   |    4 ++--
 drivers/net/wan/wanxl.c          |    8 ++++----
 fs/adfs/dir_f.c                  |    4 ++--
 fs/binfmt_elf.c                  |    8 ++++----
 fs/proc/base.c                   |    4 ++--
 kernel/softirq.c                 |    4 ++--
 kernel/sys.c                     |    8 ++++----
 security/selinux/hooks.c         |    4 ++--
 sound/usb/usx2y/usbusx2y.c       |    4 ++--
 16 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index 6b68074..805c6cb 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -85,9 +85,9 @@ static int ali1563_transaction(struct i2c_adapter * a, int size)
 	outb_p(inb_p(SMB_HST_CNTL2) | HST_CNTL2_START, SMB_HST_CNTL2);
 
 	timeout = ALI1563_MAX_TIMEOUT;
-	do
+	do {
 		msleep(1);
-	while (((data = inb_p(SMB_HST_STS)) & HST_STS_BUSY) && --timeout);
+	} while (((data = inb_p(SMB_HST_STS)) & HST_STS_BUSY) && --timeout);
 
 	dev_dbg(&a->dev, "Transaction (post): STS=%02x, CNTL1=%02x, "
 		"CNTL2=%02x, CMD=%02x, ADD=%02x, DAT0=%02x, DAT1=%02x\n",
@@ -152,9 +152,9 @@ static int ali1563_block_start(struct i2c_adapter * a)
 	outb_p(inb_p(SMB_HST_CNTL2) | HST_CNTL2_START, SMB_HST_CNTL2);
 
 	timeout = ALI1563_MAX_TIMEOUT;
-	do
+	do {
 		msleep(1);
-	while (!((data = inb_p(SMB_HST_STS)) & HST_STS_DONE) && --timeout);
+	} while (!((data = inb_p(SMB_HST_STS)) & HST_STS_DONE) && --timeout);
 
 	dev_dbg(&a->dev, "Block (post): STS=%02x, CNTL1=%02x, "
 		"CNTL2=%02x, CMD=%02x, ADD=%02x, DAT0=%02x, DAT1=%02x\n",
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index eafb0c7..4ed92f2 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -626,9 +626,9 @@ ov511_i2c_write_internal(struct usb_ov511 *ov,
 			break;
 
 		/* Retry until idle */
-		do
+		do {
 			rc = reg_r(ov, R511_I2C_CTL);
-		while (rc > 0 && ((rc&1) == 0));
+		} while (rc > 0 && ((rc&1) == 0));
 		if (rc < 0)
 			break;
 
@@ -703,9 +703,9 @@ ov511_i2c_read_internal(struct usb_ov511 *ov, unsigned char reg)
 			return rc;
 
 		/* Retry until idle */
-		do
+		do {
 			 rc = reg_r(ov, R511_I2C_CTL);
-		while (rc > 0 && ((rc&1) == 0));
+		} while (rc > 0 && ((rc&1) == 0));
 		if (rc < 0)
 			return rc;
 
@@ -729,9 +729,9 @@ ov511_i2c_read_internal(struct usb_ov511 *ov, unsigned char reg)
 			return rc;
 
 		/* Retry until idle */
-		do
+		do {
 			rc = reg_r(ov, R511_I2C_CTL);
-		while (rc > 0 && ((rc&1) == 0));
+		} while (rc > 0 && ((rc&1) == 0));
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/net/atp.c b/drivers/net/atp.c
index 3d44333..f98b048 100644
--- a/drivers/net/atp.c
+++ b/drivers/net/atp.c
@@ -809,13 +809,13 @@ static void read_block(long ioaddr, int length, unsigned char *p, int data_mode)
 		outb(length == 8  ?  RdAddr | HNib | MAR  :  RdAddr | MAR,
 			 ioaddr + PAR_DATA);
 		if (data_mode <= 1) { /* Mode 0 or 1 */
-			do  *p++ = read_byte_mode0(ioaddr);  while (--length > 0);
+			do { *p++ = read_byte_mode0(ioaddr); } while (--length > 0);
 		} else	/* Mode 2 or 3 */
-			do  *p++ = read_byte_mode2(ioaddr);  while (--length > 0);
+			do { *p++ = read_byte_mode2(ioaddr); } while (--length > 0);
 	} else if (data_mode <= 5)
-		do      *p++ = read_byte_mode4(ioaddr);  while (--length > 0);
+		do { *p++ = read_byte_mode4(ioaddr); } while (--length > 0);
 	else
-		do      *p++ = read_byte_mode6(ioaddr);  while (--length > 0);
+		do { *p++ = read_byte_mode6(ioaddr); } while (--length > 0);
 
     outb(EOC+HNib+MAR, ioaddr + PAR_DATA);
 	outb(Ctrl_SelData, ioaddr + PAR_CONTROL);
diff --git a/drivers/net/eepro100.c b/drivers/net/eepro100.c
index e3e26c5..f00741c 100644
--- a/drivers/net/eepro100.c
+++ b/drivers/net/eepro100.c
@@ -855,9 +855,9 @@ static void do_slow_command(struct net_device *dev, struct speedo_private *sp, i
 {
 	void __iomem *cmd_ioaddr = sp->regs + SCBCmd;
 	int wait = 0;
-	do
+	do {
 		if (ioread8(cmd_ioaddr) == 0) break;
-	while(++wait <= 200);
+	} while(++wait <= 200);
 	if (wait > 100)
 		printk(KERN_ERR "Command %4.4x never accepted (%d polls)!\n",
 		       ioread8(cmd_ioaddr), wait);
diff --git a/drivers/net/plip.c b/drivers/net/plip.c
index 1e96542..d5a8e83 100644
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -638,14 +638,14 @@ plip_receive_packet(struct net_device *dev, struct net_local *nl,
 
 	case PLIP_PK_DATA:
 		lbuf = rcv->skb->data;
-		do
+		do {
 			if (plip_receive(nibble_timeout, dev,
 					 &rcv->nibble, &lbuf[rcv->byte]))
 				return TIMEOUT;
-		while (++rcv->byte < rcv->length.h);
-		do
+		} while (++rcv->byte < rcv->length.h);
+		do {
 			rcv->checksum += lbuf[--rcv->byte];
-		while (rcv->byte);
+		} while (rcv->byte);
 		rcv->state = PLIP_PK_CHECKSUM;
 
 	case PLIP_PK_CHECKSUM:
@@ -817,14 +817,14 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 		snd->checksum = 0;
 
 	case PLIP_PK_DATA:
-		do
+		do {
 			if (plip_send(nibble_timeout, dev,
 				      &snd->nibble, lbuf[snd->byte]))
 				return TIMEOUT;
-		while (++snd->byte < snd->length.h);
-		do
+		} while (++snd->byte < snd->length.h);
+		do {
 			snd->checksum += lbuf[--snd->byte];
-		while (snd->byte);
+		} while (snd->byte);
 		snd->state = PLIP_PK_CHECKSUM;
 
 	case PLIP_PK_CHECKSUM:
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index 7b7b171..a8a7f9a 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -922,9 +922,9 @@ static int mdio_read(struct net_device *dev, int phy_id, int location)
 	void __iomem *mdio_addr = np->base + MIICtrl + (phy_id<<7) + (location<<2);
 	int result, boguscnt=1000;
 	/* ??? Should we add a busy-wait here? */
-	do
+	do {
 		result = readl(mdio_addr);
-	while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
+	} while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
 	if (boguscnt == 0)
 		return 0;
 	if ((result & 0xffff) == 0xffff)
diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index 1b5edd6..8acacce 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -1694,9 +1694,9 @@ static void __devinit de21040_get_mac_address (struct de_private *de)
 
 	for (i = 0; i < 6; i++) {
 		int value, boguscnt = 100000;
-		do
+		do {
 			value = dr32(ROMCmd);
-		while (value < 0 && --boguscnt > 0);
+		} while (value < 0 && --boguscnt > 0);
 		de->dev->dev_addr[i] = value;
 		udelay(1);
 		if (boguscnt <= 0)
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index fa1c1c3..c585170 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1434,9 +1434,9 @@ static int __devinit tulip_init_one (struct pci_dev *pdev,
 		for (i = 0; i < 3; i++) {
 			int value, boguscnt = 100000;
 			iowrite32(0x600 | i, ioaddr + 0x98);
-			do
+			do {
 				value = ioread32(ioaddr + CSR9);
-			while (value < 0  && --boguscnt > 0);
+			} while (value < 0  && --boguscnt > 0);
 			put_unaligned(cpu_to_le16(value), ((__le16*)dev->dev_addr) + i);
 			sum += value & 0xffff;
 		}
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index d4aab8a..8fb1efd 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -413,12 +413,12 @@ static int wanxl_open(struct net_device *dev)
 	writel(1 << (DOORBELL_TO_CARD_OPEN_0 + port->node), dbr);
 
 	timeout = jiffies + HZ;
-	do
+	do {
 		if (get_status(port)->open) {
 			netif_start_queue(dev);
 			return 0;
 		}
-	while (time_after(timeout, jiffies));
+	} while (time_after(timeout, jiffies));
 
 	printk(KERN_ERR "%s: unable to open port\n", dev->name);
 	/* ask the card to close the port, should it be still alive */
@@ -440,10 +440,10 @@ static int wanxl_close(struct net_device *dev)
 	       port->card->plx + PLX_DOORBELL_TO_CARD);
 
 	timeout = jiffies + HZ;
-	do
+	do {
 		if (!get_status(port)->open)
 			break;
-	while (time_after(timeout, jiffies));
+	} while (time_after(timeout, jiffies));
 
 	if (get_status(port)->open)
 		printk(KERN_ERR "%s: unable to close port\n", dev->name);
diff --git a/fs/adfs/dir_f.c b/fs/adfs/dir_f.c
index b9b2b27..ea7df21 100644
--- a/fs/adfs/dir_f.c
+++ b/fs/adfs/dir_f.c
@@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir *dir)
 		ptr.ptr8 = bufoff(bh, i);
 		end.ptr8 = ptr.ptr8 + last - i;
 
-		do
+		do {
 			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
-		while (ptr.ptr8 < end.ptr8);
+		} while (ptr.ptr8 < end.ptr8);
 	}
 
 	/*
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 9924581..92b61d5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1379,9 +1379,9 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 {
 	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
 	int i = 0;
-	do
+	do {
 		i += 2;
-	while (auxv[i - 2] != AT_NULL);
+	} while (auxv[i - 2] != AT_NULL);
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
@@ -1523,7 +1523,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	 * Allocate a structure for each thread.
 	 */
 	rcu_read_lock();
-	do_each_thread(g, p)
+	do_each_thread(g, p) {
 		if (p->mm == dump_task->mm) {
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
@@ -1545,7 +1545,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 				info->thread->next = t;
 			}
 		}
-	while_each_thread(g, p);
+	} while_each_thread(g, p);
 	rcu_read_unlock();
 
 	/*
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c5e412a..39b0de5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -265,9 +265,9 @@ static int proc_pid_auxv(struct task_struct *task, char *buffer)
 	struct mm_struct *mm = get_task_mm(task);
 	if (mm) {
 		unsigned int nwords = 0;
-		do
+		do {
 			nwords += 2;
-		while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
+		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
 		res = nwords * sizeof(mm->saved_auxv[0]);
 		if (res > PAGE_SIZE)
 			res = PAGE_SIZE;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3c44956..c3940bd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -482,9 +482,9 @@ void tasklet_kill(struct tasklet_struct *t)
 		printk("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do
+		do {
 			yield();
-		while (test_bit(TASKLET_STATE_SCHED, &t->state));
+		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
diff --git a/kernel/sys.c b/kernel/sys.c
index 6a0cc71..ff37a32 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -181,10 +181,10 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 				if ((who != current->uid) && !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
-			do_each_thread(g, p)
+			do_each_thread(g, p) {
 				if (p->uid == who)
 					error = set_one_prio(p, niceval, error);
-			while_each_thread(g, p);
+			} while_each_thread(g, p);
 			if (who != current->uid)
 				free_uid(user);		/* For find_user() */
 			break;
@@ -243,13 +243,13 @@ asmlinkage long sys_getpriority(int which, int who)
 				if ((who != current->uid) && !(user = find_user(who)))
 					goto out_unlock;	/* No processes for this user */
 
-			do_each_thread(g, p)
+			do_each_thread(g, p) {
 				if (p->uid == who) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
-			while_each_thread(g, p);
+			} while_each_thread(g, p);
 			if (who != current->uid)
 				free_uid(user);		/* for find_user() */
 			break;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 308e2cf..3e9ea18 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5185,12 +5185,12 @@ static int selinux_setprocattr(struct task_struct *p,
 			struct task_struct *g, *t;
 			struct mm_struct *mm = p->mm;
 			read_lock(&tasklist_lock);
-			do_each_thread(g, t)
+			do_each_thread(g, t) {
 				if (t->mm == mm && t != p) {
 					read_unlock(&tasklist_lock);
 					return -EPERM;
 				}
-			while_each_thread(g, t);
+			} while_each_thread(g, t);
 			read_unlock(&tasklist_lock);
 		}
 
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index e5981a6..2d72467 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -227,9 +227,9 @@ static void i_usX2Y_In04Int(struct urb *urb)
 	
 	if (usX2Y->US04) {
 		if (0 == usX2Y->US04->submitted)
-			do
+			do {
 				err = usb_submit_urb(usX2Y->US04->urb[usX2Y->US04->submitted++], GFP_ATOMIC);
-			while (!err && usX2Y->US04->submitted < usX2Y->US04->len);
+			} while (!err && usX2Y->US04->submitted < usX2Y->US04->len);
 	} else
 		if (us428ctls && us428ctls->p4outLast >= 0 && us428ctls->p4outLast < N_us428_p4out_BUFS) {
 			if (us428ctls->p4outLast != us428ctls->p4outSent) {
-- 
1.5.5.1.270.g89765



