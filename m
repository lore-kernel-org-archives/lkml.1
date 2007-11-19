Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbXKSPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbXKSPBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXKSPBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:01:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35937 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752979AbXKSPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:01:21 -0500
Date: Mon, 19 Nov 2007 14:59:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] tty_io:  Drag screaming into coding style compliance
Message-ID: <20071119145931.3637eec1@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_io.c linux-2.6.24-rc2-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_io.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/tty_io.c	2007-11-16 18:20:59.000000000 +0000
@@ -19,7 +19,7 @@
  * Also restructured routines so that there is more of a separation
  * between the high-level tty routines (tty_io.c and tty_ioctl.c) and
  * the low-level tty routines (serial.c, pty.c, console.c).  This
- * makes for cleaner and more compact code.  -TYT, 9/17/92 
+ * makes for cleaner and more compact code.  -TYT, 9/17/92
  *
  * Modified by Fred N. van Kempen, 01/29/93, to add line disciplines
  * which can be dynamically activated and de-activated by the line
@@ -41,7 +41,7 @@
  *
  * New TIOCLINUX variants added.
  *	-- mj@k332.feld.cvut.cz, 19-Nov-95
- * 
+ *
  * Restrict vt switching via ioctl()
  *      -- grif@cs.ucr.edu, 5-Dec-95
  *
@@ -62,7 +62,8 @@
  *      -- Russell King <rmk@arm.linux.org.uk>
  *
  * Move do_SAK() into process context.  Less stack use in devfs functions.
- * alloc_tty_struct() always uses kmalloc() -- Andrew Morton <andrewm@uow.edu.eu> 17Mar01
+ * alloc_tty_struct() always uses kmalloc()
+ *			 -- Andrew Morton <andrewm@uow.edu.eu> 17Mar01
  */
 
 #include <linux/types.h>
@@ -126,7 +127,7 @@
 /* This list gets poked at by procfs and various bits of boot up code. This
    could do with some rationalisation such as pulling the tty proc function
    into this file */
-   
+
 LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
 
 /* Mutex to protect creating and releasing a tty. This is shared with
@@ -136,7 +137,7 @@
 
 #ifdef CONFIG_UNIX98_PTYS
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
-extern int pty_limit;		/* Config limit on Unix98 ptys */
+extern int pty_limit;			/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
 static DECLARE_MUTEX(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
@@ -146,19 +147,20 @@
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
-ssize_t redirected_tty_write(struct file *, const char __user *, size_t, loff_t *);
+ssize_t redirected_tty_write(struct file *, const char __user *,
+							size_t, loff_t *);
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
-int tty_ioctl(struct inode * inode, struct file * file,
+int tty_ioctl(struct inode *inode, struct file *file,
 	      unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
-static long tty_compat_ioctl(struct file * file, unsigned int cmd,
+static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg);
 #else
 #define tty_compat_ioctl NULL
 #endif
-static int tty_fasync(int fd, struct file * filp, int on);
+static int tty_fasync(int fd, struct file *filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
@@ -244,7 +246,7 @@
 #ifdef CHECK_TTY_COUNT
 	struct list_head *p;
 	int count = 0;
-	
+
 	file_list_lock();
 	list_for_each(p, &tty->tty_files) {
 		count++;
@@ -281,11 +283,11 @@
 static void tty_buffer_free_all(struct tty_struct *tty)
 {
 	struct tty_buffer *thead;
-	while((thead = tty->buf.head) != NULL) {
+	while ((thead = tty->buf.head) != NULL) {
 		tty->buf.head = thead->next;
 		kfree(thead);
 	}
-	while((thead = tty->buf.free) != NULL) {
+	while ((thead = tty->buf.free) != NULL) {
 		tty->buf.free = thead->next;
 		kfree(thead);
 	}
@@ -331,7 +333,7 @@
 	if (tty->buf.memory_used + size > 65536)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
-	if(p == NULL)
+	if (p == NULL)
 		return NULL;
 	p->used = 0;
 	p->size = size;
@@ -361,7 +363,7 @@
 	tty->buf.memory_used -= b->size;
 	WARN_ON(tty->buf.memory_used < 0);
 
-	if(b->size >= 512)
+	if (b->size >= 512)
 		kfree(b);
 	else {
 		b->next = tty->buf.free;
@@ -384,7 +386,7 @@
 {
 	struct tty_buffer *thead;
 
-	while((thead = tty->buf.head) != NULL) {
+	while ((thead = tty->buf.head) != NULL) {
 		tty->buf.head = thead->next;
 		tty_buffer_free(tty, thead);
 	}
@@ -436,9 +438,9 @@
 static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
 {
 	struct tty_buffer **tbh = &tty->buf.free;
-	while((*tbh) != NULL) {
+	while ((*tbh) != NULL) {
 		struct tty_buffer *t = *tbh;
-		if(t->size >= size) {
+		if (t->size >= size) {
 			*tbh = t->next;
 			t->next = NULL;
 			t->used = 0;
@@ -450,7 +452,7 @@
 		tbh = &((*tbh)->next);
 	}
 	/* Round the buffer size out */
-	size = (size + 0xFF) & ~ 0xFF;
+	size = (size + 0xFF) & ~0xFF;
 	return tty_buffer_alloc(tty, size);
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
@@ -520,7 +522,7 @@
 		int space = tty_buffer_request_room(tty, size - copied);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-		if(unlikely(space == 0))
+		if (unlikely(space == 0))
 			break;
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
@@ -556,7 +558,7 @@
 		int space = tty_buffer_request_room(tty, size - copied);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-		if(unlikely(space == 0))
+		if (unlikely(space == 0))
 			break;
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
@@ -608,7 +610,8 @@
  *	Locking: May call functions taking tty->buf.lock
  */
 
-int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars, size_t size)
+int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
+								size_t size)
 {
 	int space = tty_buffer_request_room(tty, size);
 	if (likely(space)) {
@@ -638,7 +641,8 @@
  *	Locking: May call functions taking tty->buf.lock
  */
 
-int tty_prepare_flip_string_flags(struct tty_struct *tty, unsigned char **chars, char **flags, size_t size)
+int tty_prepare_flip_string_flags(struct tty_struct *tty,
+			unsigned char **chars, char **flags, size_t size)
 {
 	int space = tty_buffer_request_room(tty, size);
 	if (likely(space)) {
@@ -660,12 +664,12 @@
  *	@num: line discipline number
  *
  *	This is probably overkill for real world processors but
- *	they are not on hot paths so a little discipline won't do 
+ *	they are not on hot paths so a little discipline won't do
  *	any harm.
  *
  *	Locking: takes termios_mutex
  */
- 
+
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 {
 	mutex_lock(&tty->termios_mutex);
@@ -678,10 +682,11 @@
  *	must be taken with irqs off because there are hangup path
  *	callers who will do ldisc lookups and cannot sleep.
  */
- 
+
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
-static struct tty_ldisc tty_ldiscs[NR_LDISCS];	/* line disc dispatch table */
+/* Line disc dispatch table */
+static struct tty_ldisc tty_ldiscs[NR_LDISCS];
 
 /**
  *	tty_register_ldisc	-	install a line discipline
@@ -700,17 +705,17 @@
 {
 	unsigned long flags;
 	int ret = 0;
-	
+
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
-	
+
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	tty_ldiscs[disc] = *new_ldisc;
 	tty_ldiscs[disc].num = disc;
 	tty_ldiscs[disc].flags |= LDISC_FLAG_DEFINED;
 	tty_ldiscs[disc].refcount = 0;
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	
+
 	return ret;
 }
 EXPORT_SYMBOL(tty_register_ldisc);
@@ -766,20 +771,18 @@
 
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return NULL;
-	
+
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 
 	ld = &tty_ldiscs[disc];
 	/* Check the entry is defined */
-	if(ld->flags & LDISC_FLAG_DEFINED)
-	{
+	if (ld->flags & LDISC_FLAG_DEFINED) {
 		/* If the module is being unloaded we can't use it */
 		if (!try_module_get(ld->owner))
-		       	ld = NULL;
+			ld = NULL;
 		else /* lock it */
 			ld->refcount++;
-	}
-	else
+	} else
 		ld = NULL;
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 	return ld;
@@ -802,9 +805,9 @@
 {
 	struct tty_ldisc *ld;
 	unsigned long flags;
-	
+
 	BUG_ON(disc < N_TTY || disc >= NR_LDISCS);
-		
+
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	ld = &tty_ldiscs[disc];
 	BUG_ON(ld->refcount == 0);
@@ -812,7 +815,7 @@
 	module_put(ld->owner);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
-	
+
 EXPORT_SYMBOL_GPL(tty_ldisc_put);
 
 /**
@@ -851,11 +854,10 @@
 	unsigned long flags;
 	struct tty_ldisc *ld;
 	int ret = 0;
-	
+
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	ld = &tty->ldisc;
-	if(test_bit(TTY_LDISC, &tty->flags))
-	{
+	if (test_bit(TTY_LDISC, &tty->flags)) {
 		ld->refcount++;
 		ret = 1;
 	}
@@ -867,8 +869,8 @@
  *	tty_ldisc_ref_wait	-	wait for the tty ldisc
  *	@tty: tty device
  *
- *	Dereference the line discipline for the terminal and take a 
- *	reference to it. If the line discipline is in flux then 
+ *	Dereference the line discipline for the terminal and take a
+ *	reference to it. If the line discipline is in flux then
  *	wait patiently until it changes.
  *
  *	Note: Must not be called from an IRQ/timer context. The caller
@@ -878,12 +880,12 @@
  *
  *	Locking: call functions take tty_ldisc_lock
  */
- 
+
 struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
 	/* wait_event is a macro */
 	wait_event(tty_ldisc_wait, tty_ldisc_try(tty));
-	if(tty->ldisc.refcount == 0)
+	if (tty->ldisc.refcount == 0)
 		printk(KERN_ERR "tty_ldisc_ref_wait\n");
 	return &tty->ldisc;
 }
@@ -894,16 +896,16 @@
  *	tty_ldisc_ref		-	get the tty ldisc
  *	@tty: tty device
  *
- *	Dereference the line discipline for the terminal and take a 
- *	reference to it. If the line discipline is in flux then 
+ *	Dereference the line discipline for the terminal and take a
+ *	reference to it. If the line discipline is in flux then
  *	return NULL. Can be called from IRQ and timer functions.
  *
  *	Locking: called functions take tty_ldisc_lock
  */
- 
+
 struct tty_ldisc *tty_ldisc_ref(struct tty_struct *tty)
 {
-	if(tty_ldisc_try(tty))
+	if (tty_ldisc_try(tty))
 		return &tty->ldisc;
 	return NULL;
 }
@@ -919,19 +921,19 @@
  *
  *	Locking: takes tty_ldisc_lock
  */
- 
+
 void tty_ldisc_deref(struct tty_ldisc *ld)
 {
 	unsigned long flags;
 
 	BUG_ON(ld == NULL);
-		
+
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	if(ld->refcount == 0)
+	if (ld->refcount == 0)
 		printk(KERN_ERR "tty_ldisc_deref: no references.\n");
 	else
 		ld->refcount--;
-	if(ld->refcount == 0)
+	if (ld->refcount == 0)
 		wake_up(&tty_ldisc_wait);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
@@ -954,7 +956,7 @@
 	set_bit(TTY_LDISC, &tty->flags);
 	wake_up(&tty_ldisc_wait);
 }
-	
+
 /**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
@@ -966,7 +968,7 @@
  *	Locking: takes tty_ldisc_lock.
  *		 called functions take termios_mutex
  */
- 
+
 static int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval = 0;
@@ -1022,7 +1024,7 @@
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	if (tty->ldisc.refcount || (o_tty && o_tty->ldisc.refcount)) {
-		if(tty->ldisc.refcount) {
+		if (tty->ldisc.refcount) {
 			/* Free the new ldisc we grabbed. Must drop the lock
 			   first. */
 			spin_unlock_irqrestore(&tty_ldisc_lock, flags);
@@ -1031,14 +1033,14 @@
 			 * There are several reasons we may be busy, including
 			 * random momentary I/O traffic. We must therefore
 			 * retry. We could distinguish between blocking ops
-			 * and retries if we made tty_ldisc_wait() smarter. That
-			 * is up for discussion.
+			 * and retries if we made tty_ldisc_wait() smarter.
+			 * That is up for discussion.
 			 */
 			if (wait_event_interruptible(tty_ldisc_wait, tty->ldisc.refcount == 0) < 0)
 				return -ERESTARTSYS;
 			goto restart;
 		}
-		if(o_tty && o_tty->ldisc.refcount) {
+		if (o_tty && o_tty->ldisc.refcount) {
 			spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 			tty_ldisc_put(ldisc);
 			if (wait_event_interruptible(tty_ldisc_wait, o_tty->ldisc.refcount == 0) < 0)
@@ -1046,9 +1048,10 @@
 			goto restart;
 		}
 	}
-
-	/* if the TTY_LDISC bit is set, then we are racing against another ldisc change */
-
+	/*
+	 *	If the TTY_LDISC bit is set, then we are racing against
+	 *	another ldisc change
+	 */
 	if (!test_bit(TTY_LDISC, &tty->flags)) {
 		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 		tty_ldisc_put(ldisc);
@@ -1072,7 +1075,6 @@
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate
 	 */
-	 
 	flush_scheduled_work();
 	/* Shutdown the current discipline. */
 	if (tty->ldisc.close)
@@ -1106,21 +1108,21 @@
 	/* At this point we hold a reference to the new ldisc and a
 	   a reference to the old ldisc. If we ended up flipping back
 	   to the existing ldisc we have two references to it */
-	
+
 	if (tty->ldisc.num != o_ldisc.num && tty->driver->set_ldisc)
 		tty->driver->set_ldisc(tty);
-		
+
 	tty_ldisc_put(o_ldisc.num);
-	
+
 	/*
 	 *	Allow ldisc referencing to occur as soon as the driver
 	 *	ldisc callback completes.
 	 */
-	 
+
 	tty_ldisc_enable(tty);
 	if (o_tty)
 		tty_ldisc_enable(o_tty);
-	
+
 	/* Restart it in case no characters kick it off. Safe if
 	   already running */
 	if (work)
@@ -1164,7 +1166,7 @@
  *	Locking: none
  */
 
-int tty_check_change(struct tty_struct * tty)
+int tty_check_change(struct tty_struct *tty)
 {
 	if (current->signal->tty != tty)
 		return 0;
@@ -1185,31 +1187,31 @@
 
 EXPORT_SYMBOL(tty_check_change);
 
-static ssize_t hung_up_tty_read(struct file * file, char __user * buf,
+static ssize_t hung_up_tty_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
-static ssize_t hung_up_tty_write(struct file * file, const char __user * buf,
+static ssize_t hung_up_tty_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	return -EIO;
 }
 
 /* No kernel lock held - none needed ;) */
-static unsigned int hung_up_tty_poll(struct file * filp, poll_table * wait)
+static unsigned int hung_up_tty_poll(struct file *filp, poll_table *wait)
 {
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
+static int hung_up_tty_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
 
-static long hung_up_tty_compat_ioctl(struct file * file,
+static long hung_up_tty_compat_ioctl(struct file *file,
 				     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
@@ -1274,15 +1276,15 @@
  *	informs the line discipline if present that the driver is ready
  *	to receive more output data.
  */
- 
+
 void tty_wakeup(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
-	
+
 	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags)) {
 		ld = tty_ldisc_ref(tty);
-		if(ld) {
-			if(ld->write_wakeup)
+		if (ld) {
+			if (ld->write_wakeup)
 				ld->write_wakeup(tty);
 			tty_ldisc_deref(ld);
 		}
@@ -1299,12 +1301,12 @@
  *	Flush the line discipline queue (if any) for this tty. If there
  *	is no line discipline active this is a no-op.
  */
- 
+
 void tty_ldisc_flush(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld = tty_ldisc_ref(tty);
-	if(ld) {
-		if(ld->flush_buffer)
+	if (ld) {
+		if (ld->flush_buffer)
 			ld->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
@@ -1328,7 +1330,7 @@
 	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
 	mutex_unlock(&tty->termios_mutex);
 }
-	
+
 /**
  *	do_tty_hangup		-	actual handler for hangup events
  *	@work: tty device
@@ -1355,7 +1357,7 @@
 {
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
-	struct file * cons_filp = NULL;
+	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
 	struct tty_ldisc *ld;
@@ -1373,7 +1375,7 @@
 		redirect = NULL;
 	}
 	spin_unlock(&redirect_lock);
-	
+
 	check_tty_count(tty, "do_tty_hangup");
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
@@ -1387,13 +1389,14 @@
 		filp->f_op = &hung_up_tty_fops;
 	}
 	file_list_unlock();
-	
-	/* FIXME! What are the locking issues here? This may me overdoing things..
-	 * this question is especially important now that we've removed the irqlock. */
-
+	/*
+	 * FIXME! What are the locking issues here? This may me overdoing
+	 * things... This question is especially important now that we've
+	 * removed the irqlock.
+	 */
 	ld = tty_ldisc_ref(tty);
-	if(ld != NULL)	/* We may have no line discipline at this point */
-	{
+	if (ld != NULL) {
+		/* We may have no line discipline at this point */
 		if (ld->flush_buffer)
 			ld->flush_buffer(tty);
 		if (tty->driver->flush_buffer)
@@ -1404,26 +1407,24 @@
 		if (ld->hangup)
 			ld->hangup(tty);
 	}
-
-	/* FIXME: Once we trust the LDISC code better we can wait here for
-	   ldisc completion and fix the driver call race */
-	   
+	/*
+	 * FIXME: Once we trust the LDISC code better we can wait here for
+	 * ldisc completion and fix the driver call race
+	 */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
-
 	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY.
 	 */
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS)
 		tty_reset_termios(tty);
-	
 	/* Defer ldisc switch */
 	/* tty_deferred_ldisc_switch(N_TTY);
-	
+
 	  This should get done automatically when the port closes and
 	  tty_release is called */
-	
+
 	read_lock(&tasklist_lock);
 	if (tty->session) {
 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
@@ -1451,10 +1452,10 @@
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
 	/*
-	 *	If one of the devices matches a console pointer, we
-	 *	cannot just call hangup() because that will cause
-	 *	tty->count and state->count to go out of sync.
-	 *	So we just call close() the right number of times.
+	 * If one of the devices matches a console pointer, we
+	 * cannot just call hangup() because that will cause
+	 * tty->count and state->count to go out of sync.
+	 * So we just call close() the right number of times.
 	 */
 	if (cons_filp) {
 		if (tty->driver->close)
@@ -1462,12 +1463,12 @@
 				tty->driver->close(tty, cons_filp);
 	} else if (tty->driver->hangup)
 		(tty->driver->hangup)(tty);
-		
-	/* We don't want to have driver/ldisc interactions beyond
-	   the ones we did here. The driver layer expects no
-	   calls after ->hangup() from the ldisc side. However we
-	   can't yet guarantee all that */
-
+	/*
+	 * We don't want to have driver/ldisc interactions beyond
+	 * the ones we did here. The driver layer expects no
+	 * calls after ->hangup() from the ldisc side. However we
+	 * can't yet guarantee all that.
+	 */
 	set_bit(TTY_HUPPED, &tty->flags);
 	if (ld) {
 		tty_ldisc_enable(tty);
@@ -1486,11 +1487,10 @@
  *	schedule a hangup sequence to run after this event.
  */
 
-void tty_hangup(struct tty_struct * tty)
+void tty_hangup(struct tty_struct *tty)
 {
 #ifdef TTY_DEBUG_HANGUP
 	char	buf[64];
-	
 	printk(KERN_DEBUG "%s hangup...\n", tty_name(tty, buf));
 #endif
 	schedule_work(&tty->hangup_work);
@@ -1507,7 +1507,7 @@
  *	is complete. That guarantee is necessary for security reasons.
  */
 
-void tty_vhangup(struct tty_struct * tty)
+void tty_vhangup(struct tty_struct *tty)
 {
 #ifdef TTY_DEBUG_HANGUP
 	char	buf[64];
@@ -1516,6 +1516,7 @@
 #endif
 	do_tty_hangup(&tty->hangup_work);
 }
+
 EXPORT_SYMBOL(tty_vhangup);
 
 /**
@@ -1526,7 +1527,7 @@
  *	loss
  */
 
-int tty_hung_up_p(struct file * filp)
+int tty_hung_up_p(struct file *filp)
 {
 	return (filp->f_op == &hung_up_tty_fops);
 }
@@ -1534,8 +1535,12 @@
 EXPORT_SYMBOL(tty_hung_up_p);
 
 /**
- * is_tty	-	checker whether file is a TTY
+ *	is_tty	-	checker whether file is a TTY
+ *	@filp:		file handle that may be a tty
+ *
+ *	Check if the file handle is a tty handle.
  */
+
 int is_tty(struct file *filp)
 {
 	return filp->f_op->read == tty_read
@@ -1601,7 +1606,7 @@
 			put_pid(old_pgrp);
 		}
 		mutex_unlock(&tty_mutex);
-		unlock_kernel();	
+		unlock_kernel();
 		return;
 	}
 	if (tty_pgrp) {
@@ -1711,7 +1716,6 @@
 	}
 	if (tty->driver->start)
 		(tty->driver->start)(tty);
-
 	/* If we have a running line discipline it may need kicking */
 	tty_wakeup(tty);
 }
@@ -1735,11 +1739,11 @@
  *	in new code. Multiple read calls may be outstanding in parallel.
  */
 
-static ssize_t tty_read(struct file * file, char __user * buf, size_t count, 
+static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
 	int i;
-	struct tty_struct * tty;
+	struct tty_struct *tty;
 	struct inode *inode;
 	struct tty_ldisc *ld;
 
@@ -1755,7 +1759,7 @@
 	ld = tty_ldisc_ref_wait(tty);
 	lock_kernel();
 	if (ld->read)
-		i = (ld->read)(tty,file,buf,count);
+		i = (ld->read)(tty, file, buf, count);
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
@@ -1795,7 +1799,7 @@
 {
 	ssize_t ret, written = 0;
 	unsigned int chunk;
-	
+
 	ret = tty_write_lock(tty, file->f_flags & O_NDELAY);
 	if (ret < 0)
 		return ret;
@@ -1891,21 +1895,22 @@
  *	kernel lock for historical reasons. New code should not rely on this.
  */
 
-static ssize_t tty_write(struct file * file, const char __user * buf, size_t count,
-			 loff_t *ppos)
+static ssize_t tty_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
-	struct tty_struct * tty;
+	struct tty_struct *tty;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	ssize_t ret;
 	struct tty_ldisc *ld;
-	
+
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
-	if (!tty || !tty->driver->write || (test_bit(TTY_IO_ERROR, &tty->flags)))
-		return -EIO;
+	if (!tty || !tty->driver->write ||
+		(test_bit(TTY_IO_ERROR, &tty->flags)))
+			return -EIO;
 
-	ld = tty_ldisc_ref_wait(tty);		
+	ld = tty_ldisc_ref_wait(tty);
 	if (!ld->write)
 		ret = -EIO;
 	else
@@ -1914,8 +1919,8 @@
 	return ret;
 }
 
-ssize_t redirected_tty_write(struct file * file, const char __user * buf, size_t count,
-			 loff_t *ppos)
+ssize_t redirected_tty_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	struct file *p = NULL;
 
@@ -1932,7 +1937,6 @@
 		fput(p);
 		return res;
 	}
-
 	return tty_write(file, buf, count, ppos);
 }
 
@@ -1954,8 +1958,8 @@
 	int i = index + driver->name_base;
 	/* ->name is initialized to "ttyp", but "tty" is expected */
 	sprintf(p, "%s%c%x",
-			driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
-			ptychar[i >> 4 & 0xf], i & 0xf);
+		driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
+		ptychar[i >> 4 & 0xf], i & 0xf);
 }
 
 /**
@@ -2034,7 +2038,7 @@
 	 * First time open is complex, especially for PTY devices.
 	 * This code guarantees that either everything succeeds and the
 	 * TTY is ready for operation, or else the table slots are vacated
-	 * and the allocated memory released.  (Except that the termios 
+	 * and the allocated memory released.  (Except that the termios
 	 * and locked termios may be retained.)
 	 */
 
@@ -2048,7 +2052,7 @@
 	ltp = o_ltp = NULL;
 
 	tty = alloc_tty_struct();
-	if(!tty)
+	if (!tty)
 		goto fail_no_mem;
 	initialize_tty_struct(tty);
 	tty->driver = driver;
@@ -2109,9 +2113,8 @@
 		/*
 		 * Everything allocated ... set up the o_tty structure.
 		 */
-		if (!(driver->other->flags & TTY_DRIVER_DEVPTS_MEM)) {
+		if (!(driver->other->flags & TTY_DRIVER_DEVPTS_MEM))
 			driver->other->ttys[idx] = o_tty;
-		}
 		if (!*o_tp_loc)
 			*o_tp_loc = o_tp;
 		if (!*o_ltp_loc)
@@ -2127,15 +2130,14 @@
 		o_tty->link = tty;
 	}
 
-	/* 
+	/*
 	 * All structures have been allocated, so now we install them.
 	 * Failures after this point use release_tty to clean up, so
 	 * there's no need to null out the local pointers.
 	 */
-	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
+	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM))
 		driver->ttys[idx] = tty;
-	}
-	
+
 	if (!*tp_loc)
 		*tp_loc = tp;
 	if (!*ltp_loc)
@@ -2148,7 +2150,7 @@
 	driver->refcount++;
 	tty->count++;
 
-	/* 
+	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
@@ -2185,7 +2187,7 @@
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
 	    driver->subtype == PTY_TYPE_MASTER) {
 		/*
-		 * special case for PTY masters: only one open permitted, 
+		 * special case for PTY masters: only one open permitted,
 		 * and the slave side open count is incremented as well.
 		 */
 		if (tty->count) {
@@ -2198,11 +2200,11 @@
 	tty->driver = driver; /* N.B. why do this every time?? */
 
 	/* FIXME */
-	if(!test_bit(TTY_LDISC, &tty->flags))
+	if (!test_bit(TTY_LDISC, &tty->flags))
 		printk(KERN_ERR "init_dev but no ldisc\n");
 success:
 	*ret_tty = tty;
-	
+
 	/* All paths come through here to release the mutex */
 end_init:
 	return retval;
@@ -2304,7 +2306,7 @@
  * WSH 09/09/97: rewritten to avoid some nasty race conditions that could
  * lead to double frees or releasing memory still in use.
  */
-static void release_dev(struct file * filp)
+static void release_dev(struct file *filp)
 {
 	struct tty_struct *tty, *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
@@ -2312,9 +2314,10 @@
 	int	idx;
 	char	buf[64];
 	unsigned long flags;
-	
+
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "release_dev"))
+	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
+							"release_dev"))
 		return;
 
 	check_tty_count(tty, "release_dev");
@@ -2374,7 +2377,7 @@
 			       idx, tty->name);
 			return;
 		}
-		if (o_tty->termios_locked != 
+		if (o_tty->termios_locked !=
 		      tty->driver->other->termios_locked[idx]) {
 			printk(KERN_DEBUG "release_dev: other->termios_locked["
 					  "%d] not o_termios_locked for (%s)\n",
@@ -2410,7 +2413,7 @@
 	while (1) {
 		/* Guard against races with tty->count changes elsewhere and
 		   opens on /dev/tty */
-		   
+
 		mutex_lock(&tty_mutex);
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
@@ -2444,11 +2447,11 @@
 				    "active!\n", tty_name(tty, buf));
 		mutex_unlock(&tty_mutex);
 		schedule();
-	}	
+	}
 
 	/*
-	 * The closing flags are now consistent with the open counts on 
-	 * both sides, and we've completed the last operation that could 
+	 * The closing flags are now consistent with the open counts on
+	 * both sides, and we've completed the last operation that could
 	 * block, so it's safe to proceed with closing.
 	 */
 	if (pty_master) {
@@ -2464,7 +2467,7 @@
 		       tty->count, tty_name(tty, buf));
 		tty->count = 0;
 	}
-	
+
 	/*
 	 * We've decremented tty->count, so we need to remove this file
 	 * descriptor off the tty->tty_files list; this serves two
@@ -2484,9 +2487,9 @@
 	 * case of a pty we may have to wait around for the other side
 	 * to close, and TTY_CLOSING makes sure we can't be reopened.
 	 */
-	if(tty_closing)
+	if (tty_closing)
 		set_bit(TTY_CLOSING, &tty->flags);
-	if(o_tty_closing)
+	if (o_tty_closing)
 		set_bit(TTY_CLOSING, &o_tty->flags);
 
 	/*
@@ -2507,7 +2510,7 @@
 	/* check whether both sides are closing ... */
 	if (!tty_closing || (o_tty && !o_tty_closing))
 		return;
-	
+
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "freeing tty structure...");
 #endif
@@ -2522,17 +2525,16 @@
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate
 	 */
-	 
+
 	flush_scheduled_work();
-	
+
 	/*
 	 * Wait for any short term users (we know they are just driver
 	 * side waiters as the file is closing so user count on the file
 	 * side is zero.
 	 */
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	while(tty->ldisc.refcount)
-	{
+	while (tty->ldisc.refcount) {
 		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 		wait_event(tty_ldisc_wait, tty->ldisc.refcount == 0);
 		spin_lock_irqsave(&tty_ldisc_lock, flags);
@@ -2547,12 +2549,12 @@
 	if (tty->ldisc.close)
 		(tty->ldisc.close)(tty);
 	tty_ldisc_put(tty->ldisc.num);
-	
+
 	/*
 	 *	Switch the line discipline back
 	 */
 	tty_ldisc_assign(tty, tty_ldisc_get(N_TTY));
-	tty_set_termios_ldisc(tty,N_TTY); 
+	tty_set_termios_ldisc(tty, N_TTY);
 	if (o_tty) {
 		/* FIXME: could o_tty be in setldisc here ? */
 		clear_bit(TTY_LDISC, &o_tty->flags);
@@ -2560,7 +2562,7 @@
 			(o_tty->ldisc.close)(o_tty);
 		tty_ldisc_put(o_tty->ldisc.num);
 		tty_ldisc_assign(o_tty, tty_ldisc_get(N_TTY));
-		tty_set_termios_ldisc(o_tty,N_TTY); 
+		tty_set_termios_ldisc(o_tty, N_TTY);
 	}
 	/*
 	 * The release_tty function takes care of the details of clearing
@@ -2600,7 +2602,7 @@
  *		 ->siglock protects ->signal/->sighand
  */
 
-static int tty_open(struct inode * inode, struct file * filp)
+static int tty_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
 	int noctty, retval;
@@ -2610,15 +2612,15 @@
 	unsigned short saved_flags = filp->f_flags;
 
 	nonseekable_open(inode, filp);
-	
+
 retry_open:
 	noctty = filp->f_flags & O_NOCTTY;
 	index  = -1;
 	retval = 0;
-	
+
 	mutex_lock(&tty_mutex);
 
-	if (device == MKDEV(TTYAUX_MAJOR,0)) {
+	if (device == MKDEV(TTYAUX_MAJOR, 0)) {
 		tty = get_current_tty();
 		if (!tty) {
 			mutex_unlock(&tty_mutex);
@@ -2631,7 +2633,7 @@
 		goto got_driver;
 	}
 #ifdef CONFIG_VT
-	if (device == MKDEV(TTY_MAJOR,0)) {
+	if (device == MKDEV(TTY_MAJOR, 0)) {
 		extern struct tty_driver *console_driver;
 		driver = console_driver;
 		index = fg_console;
@@ -2639,7 +2641,7 @@
 		goto got_driver;
 	}
 #endif
-	if (device == MKDEV(TTYAUX_MAJOR,1)) {
+	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
 		driver = console_device(&index);
 		if (driver) {
 			/* Don't let /dev/console block */
@@ -2679,7 +2681,8 @@
 	}
 	filp->f_flags = saved_flags;
 
-	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) && !capable(CAP_SYS_ADMIN))
+	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) &&
+						!capable(CAP_SYS_ADMIN))
 		retval = -EBUSY;
 
 	if (retval) {
@@ -2723,11 +2726,11 @@
  *	Allocate a unix98 pty master device from the ptmx driver.
  *
  *	Locking: tty_mutex protects theinit_dev work. tty->count should
- 		protect the rest.
+ * 		protect the rest.
  *		allocated_ptys_lock handles the list of free pty numbers
  */
 
-static int ptmx_open(struct inode * inode, struct file * filp)
+static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
 	int retval;
@@ -2759,7 +2762,7 @@
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
 	mutex_unlock(&tty_mutex);
-	
+
 	if (retval)
 		goto out;
 
@@ -2800,7 +2803,7 @@
  *		Takes bkl. See release_dev
  */
 
-static int tty_release(struct inode * inode, struct file * filp)
+static int tty_release(struct inode *inode, struct file *filp)
 {
 	lock_kernel();
 	release_dev(filp);
@@ -2820,16 +2823,16 @@
  *	may be re-entered freely by other callers.
  */
 
-static unsigned int tty_poll(struct file * filp, poll_table * wait)
+static unsigned int tty_poll(struct file *filp, poll_table *wait)
 {
-	struct tty_struct * tty;
+	struct tty_struct *tty;
 	struct tty_ldisc *ld;
 	int ret = 0;
 
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
-		
+
 	ld = tty_ldisc_ref_wait(tty);
 	if (ld->poll)
 		ret = (ld->poll)(tty, filp, wait);
@@ -2837,15 +2840,15 @@
 	return ret;
 }
 
-static int tty_fasync(int fd, struct file * filp, int on)
+static int tty_fasync(int fd, struct file *filp, int on)
 {
-	struct tty_struct * tty;
+	struct tty_struct *tty;
 	int retval;
 
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		return 0;
-	
+
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
 	if (retval <= 0)
 		return retval;
@@ -2893,7 +2896,7 @@
 {
 	char ch, mbz = 0;
 	struct tty_ldisc *ld;
-	
+
 	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (get_user(ch, p))
@@ -2915,7 +2918,7 @@
  *		is consistent.
  */
 
-static int tiocgwinsz(struct tty_struct *tty, struct winsize __user * arg)
+static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 {
 	int err;
 
@@ -2944,7 +2947,7 @@
  */
 
 static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
-	struct winsize __user * arg)
+	struct winsize __user *arg)
 {
 	struct winsize tmp_ws;
 
@@ -2960,7 +2963,7 @@
 		if (vc_lock_resize(tty->driver_data, tmp_ws.ws_col,
 					tmp_ws.ws_row)) {
 			mutex_unlock(&tty->termios_mutex);
- 			return -ENXIO;
+			return -ENXIO;
 		}
 	}
 #endif
@@ -3070,7 +3073,7 @@
 		 * This tty is already the controlling
 		 * tty for another session group!
 		 */
-		if ((arg == 1) && capable(CAP_SYS_ADMIN)) {
+		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
 			/*
 			 * Steal it away
 			 */
@@ -3303,14 +3306,14 @@
 /*
  * Split this up, as gcc can choke on it otherwise..
  */
-int tty_ioctl(struct inode * inode, struct file * file,
+int tty_ioctl(struct inode *inode, struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *tty, *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
-	
+
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
@@ -3326,13 +3329,13 @@
 	 * Break handling by driver
 	 */
 	if (!tty->driver->break_ctl) {
-		switch(cmd) {
+		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
 			if (tty->driver->ioctl)
 				return tty->driver->ioctl(tty, file, cmd, arg);
 			return -EINVAL;
-			
+
 		/* These two ioctl's always return success; even if */
 		/* the driver doesn't support them. */
 		case TCSBRK:
@@ -3354,7 +3357,7 @@
 	case TIOCSBRK:
 	case TIOCCBRK:
 	case TCSBRK:
-	case TCSBRKP:			
+	case TCSBRKP:
 		retval = tty_check_change(tty);
 		if (retval)
 			return retval;
@@ -3367,81 +3370,80 @@
 	}
 
 	switch (cmd) {
-		case TIOCSTI:
-			return tiocsti(tty, p);
-		case TIOCGWINSZ:
-			return tiocgwinsz(tty, p);
-		case TIOCSWINSZ:
-			return tiocswinsz(tty, real_tty, p);
-		case TIOCCONS:
-			return real_tty!=tty ? -EINVAL : tioccons(file);
-		case FIONBIO:
-			return fionbio(file, p);
-		case TIOCEXCL:
-			set_bit(TTY_EXCLUSIVE, &tty->flags);
-			return 0;
-		case TIOCNXCL:
-			clear_bit(TTY_EXCLUSIVE, &tty->flags);
-			return 0;
-		case TIOCNOTTY:
-			if (current->signal->tty != tty)
-				return -ENOTTY;
-			no_tty();
-			return 0;
-		case TIOCSCTTY:
-			return tiocsctty(tty, arg);
-		case TIOCGPGRP:
-			return tiocgpgrp(tty, real_tty, p);
-		case TIOCSPGRP:
-			return tiocspgrp(tty, real_tty, p);
-		case TIOCGSID:
-			return tiocgsid(tty, real_tty, p);
-		case TIOCGETD:
-			/* FIXME: check this is ok */
-			return put_user(tty->ldisc.num, (int __user *)p);
-		case TIOCSETD:
-			return tiocsetd(tty, p);
+	case TIOCSTI:
+		return tiocsti(tty, p);
+	case TIOCGWINSZ:
+		return tiocgwinsz(tty, p);
+	case TIOCSWINSZ:
+		return tiocswinsz(tty, real_tty, p);
+	case TIOCCONS:
+		return real_tty != tty ? -EINVAL : tioccons(file);
+	case FIONBIO:
+		return fionbio(file, p);
+	case TIOCEXCL:
+		set_bit(TTY_EXCLUSIVE, &tty->flags);
+		return 0;
+	case TIOCNXCL:
+		clear_bit(TTY_EXCLUSIVE, &tty->flags);
+		return 0;
+	case TIOCNOTTY:
+		if (current->signal->tty != tty)
+			return -ENOTTY;
+		no_tty();
+		return 0;
+	case TIOCSCTTY:
+		return tiocsctty(tty, arg);
+	case TIOCGPGRP:
+		return tiocgpgrp(tty, real_tty, p);
+	case TIOCSPGRP:
+		return tiocspgrp(tty, real_tty, p);
+	case TIOCGSID:
+		return tiocgsid(tty, real_tty, p);
+	case TIOCGETD:
+		/* FIXME: check this is ok */
+		return put_user(tty->ldisc.num, (int __user *)p);
+	case TIOCSETD:
+		return tiocsetd(tty, p);
 #ifdef CONFIG_VT
-		case TIOCLINUX:
-			return tioclinux(tty, arg);
+	case TIOCLINUX:
+		return tioclinux(tty, arg);
 #endif
-		/*
-		 * Break handling
-		 */
-		case TIOCSBRK:	/* Turn break on, unconditionally */
-			tty->driver->break_ctl(tty, -1);
-			return 0;
-			
-		case TIOCCBRK:	/* Turn break off, unconditionally */
-			tty->driver->break_ctl(tty, 0);
-			return 0;
-		case TCSBRK:   /* SVID version: non-zero arg --> no break */
-			/* non-zero arg means wait for all output data
-			 * to be sent (performed above) but don't send break.
-			 * This is used by the tcdrain() termios function.
-			 */
-			if (!arg)
-				return send_break(tty, 250);
-			return 0;
-		case TCSBRKP:	/* support for POSIX tcsendbreak() */	
-			return send_break(tty, arg ? arg*100 : 250);
+	/*
+	 * Break handling
+	 */
+	case TIOCSBRK:	/* Turn break on, unconditionally */
+		tty->driver->break_ctl(tty, -1);
+		return 0;
 
-		case TIOCMGET:
-			return tty_tiocmget(tty, file, p);
+	case TIOCCBRK:	/* Turn break off, unconditionally */
+		tty->driver->break_ctl(tty, 0);
+		return 0;
+	case TCSBRK:   /* SVID version: non-zero arg --> no break */
+		/* non-zero arg means wait for all output data
+		 * to be sent (performed above) but don't send break.
+		 * This is used by the tcdrain() termios function.
+		 */
+		if (!arg)
+			return send_break(tty, 250);
+		return 0;
+	case TCSBRKP:	/* support for POSIX tcsendbreak() */
+		return send_break(tty, arg ? arg*100 : 250);
 
-		case TIOCMSET:
-		case TIOCMBIC:
-		case TIOCMBIS:
-			return tty_tiocmset(tty, file, cmd, p);
-		case TCFLSH:
-			switch (arg) {
-			case TCIFLUSH:
-			case TCIOFLUSH:
-				/* flush tty buffer and allow ldisc to process ioctl */
-				tty_buffer_flush(tty);
-				break;
-			}
+	case TIOCMGET:
+		return tty_tiocmget(tty, file, p);
+	case TIOCMSET:
+	case TIOCMBIC:
+	case TIOCMBIS:
+		return tty_tiocmset(tty, file, cmd, p);
+	case TCFLSH:
+		switch (arg) {
+		case TCIFLUSH:
+		case TCIOFLUSH:
+		/* flush tty buffer and allow ldisc to process ioctl */
+			tty_buffer_flush(tty);
 			break;
+		}
+		break;
 	}
 	if (tty->driver->ioctl) {
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
@@ -3460,7 +3462,7 @@
 }
 
 #ifdef CONFIG_COMPAT
-static long tty_compat_ioctl(struct file * file, unsigned int cmd,
+static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	struct inode *inode = file->f_dentry->d_inode;
@@ -3491,7 +3493,7 @@
  * prevent trojan horses by killing all processes associated with this
  * tty when the user hits the "Secure Attention Key".  Required for
  * super-paranoid applications --- see the Orange Book for more details.
- * 
+ *
  * This code could be nicer; ideally it should send a HUP, wait a few
  * seconds, then send a INT, and then a KILL signal.  But you then
  * have to coordinate with the init process, since all processes associated
@@ -3515,16 +3517,16 @@
 	int		i;
 	struct file	*filp;
 	struct fdtable *fdt;
-	
+
 	if (!tty)
 		return;
 	session = tty->session;
-	
+
 	tty_ldisc_flush(tty);
 
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
-	
+
 	read_lock(&tasklist_lock);
 	/* Kill the entire session */
 	do_each_pid_task(session, PIDTYPE_SID, p) {
@@ -3552,7 +3554,7 @@
 			 */
 			spin_lock(&p->files->file_lock);
 			fdt = files_fdtable(p->files);
-			for (i=0; i < fdt->max_fds; i++) {
+			for (i = 0; i < fdt->max_fds; i++) {
 				filp = fcheck_files(p->files, i);
 				if (!filp)
 					continue;
@@ -3606,7 +3608,7 @@
  *	while invoking the line discipline receive_buf method. The
  *	receive_buf method is single threaded for each tty instance.
  */
- 
+
 static void flush_to_ldisc(struct work_struct *work)
 {
 	struct tty_struct *tty =
@@ -3622,7 +3624,8 @@
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
-	set_bit(TTY_FLUSHING, &tty->flags);	/* So we know a flush is running */
+	/* So we know a flush is running */
+	set_bit(TTY_FLUSHING, &tty->flags);
 	head = tty->buf.head;
 	if (head != NULL) {
 		tty->buf.head = NULL;
@@ -3796,7 +3799,8 @@
 
 void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
-	device_destroy(tty_class, MKDEV(driver->major, driver->minor_start) + index);
+	device_destroy(tty_class,
+		MKDEV(driver->major, driver->minor_start) + index);
 }
 
 EXPORT_SYMBOL(tty_register_device);
@@ -3860,7 +3864,7 @@
 int tty_register_driver(struct tty_driver *driver)
 {
 	int error;
-        int i;
+	int i;
 	dev_t dev;
 	void **p = NULL;
 
@@ -3874,8 +3878,8 @@
 	}
 
 	if (!driver->major) {
-		error = alloc_chrdev_region(&dev, driver->minor_start, driver->num,
-						driver->name);
+		error = alloc_chrdev_region(&dev, driver->minor_start,
+						driver->num, driver->name);
 		if (!error) {
 			driver->major = MAJOR(dev);
 			driver->minor_start = MINOR(dev);
@@ -3892,7 +3896,8 @@
 	if (p) {
 		driver->ttys = (struct tty_struct **)p;
 		driver->termios = (struct ktermios **)(p + driver->num);
-		driver->termios_locked = (struct ktermios **)(p + driver->num * 2);
+		driver->termios_locked = (struct ktermios **)
+							(p + driver->num * 2);
 	} else {
 		driver->ttys = NULL;
 		driver->termios = NULL;
@@ -3912,13 +3917,13 @@
 
 	if (!driver->put_char)
 		driver->put_char = tty_default_put_char;
-	
+
 	mutex_lock(&tty_mutex);
 	list_add(&driver->tty_drivers, &tty_drivers);
 	mutex_unlock(&tty_mutex);
-	
-	if ( !(driver->flags & TTY_DRIVER_DYNAMIC_DEV) ) {
-		for(i = 0; i < driver->num; i++)
+
+	if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV)) {
+		for (i = 0; i < driver->num; i++)
 		    tty_register_device(driver, i, NULL);
 	}
 	proc_tty_register_driver(driver);
@@ -4038,7 +4043,7 @@
 	(void) tty_register_ldisc(N_TTY, &tty_ldisc_N_TTY);
 
 	/*
-	 * set up the console device so that later boot sequences can 
+	 * set up the console device so that later boot sequences can
 	 * inform about problems etc..
 	 */
 	call = __con_initcall_start;
