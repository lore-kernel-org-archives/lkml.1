Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXKSPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXKSPCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXKSPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:02:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37376 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756084AbXKSPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:02:39 -0500
Date: Mon, 19 Nov 2007 15:00:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ioctl: Drag screaming into compliance with the coding
 style
Message-ID: <20071119150053.33196213@the-village.bc.nu>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_ioctl.c linux-2.6.24-rc2-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_ioctl.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/tty_ioctl.c	2007-11-16 18:27:20.000000000 +0000
@@ -50,11 +50,11 @@
  *	Locking: none
  */
 
-void tty_wait_until_sent(struct tty_struct * tty, long timeout)
+void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 {
 #ifdef TTY_DEBUG_WAIT_UNTIL_SENT
 	char buf[64];
-	
+
 	printk(KERN_DEBUG "%s wait until sent...\n", tty_name(tty, buf));
 #endif
 	if (!tty->driver->chars_in_buffer)
@@ -67,7 +67,6 @@
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);
 }
-
 EXPORT_SYMBOL(tty_wait_until_sent);
 
 static void unset_locked_termios(struct ktermios *termios,
@@ -75,8 +74,8 @@
 				 struct ktermios *locked)
 {
 	int	i;
-	
-#define NOSET_MASK(x,y,z) (x = ((x) & ~(z)) | ((y) & (z)))
+
+#define NOSET_MASK(x, y, z) (x = ((x) & ~(z)) | ((y) & (z)))
 
 	if (!locked) {
 		printk(KERN_WARNING "Warning?!? termios_locked is NULL.\n");
@@ -88,7 +87,7 @@
 	NOSET_MASK(termios->c_cflag, old->c_cflag, locked->c_cflag);
 	NOSET_MASK(termios->c_lflag, old->c_lflag, locked->c_lflag);
 	termios->c_line = locked->c_line ? old->c_line : termios->c_line;
-	for (i=0; i < NCCS; i++)
+	for (i = 0; i < NCCS; i++)
 		termios->c_cc[i] = locked->c_cc[i] ?
 			old->c_cc[i] : termios->c_cc[i];
 	/* FIXME: What should we do for i/ospeed */
@@ -163,7 +162,6 @@
 	}
 	return baud_table[cbaud];
 }
-
 EXPORT_SYMBOL(tty_termios_baud_rate);
 
 /**
@@ -203,7 +201,6 @@
 	return tty_termios_baud_rate(termios);
 #endif
 }
-
 EXPORT_SYMBOL(tty_termios_input_baud_rate);
 
 /**
@@ -338,7 +335,6 @@
 
 	return baud;
 }
-
 EXPORT_SYMBOL(tty_get_baud_rate);
 
 /**
@@ -361,7 +357,6 @@
 	new->c_ispeed = old->c_ispeed;
 	new->c_ospeed = old->c_ospeed;
 }
-
 EXPORT_SYMBOL(tty_termios_copy_hw);
 
 /**
@@ -376,16 +371,16 @@
  *	Locking: termios_sem
  */
 
-static void change_termios(struct tty_struct * tty, struct ktermios * new_termios)
+static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
 	int canon_change;
 	struct ktermios old_termios = *tty->termios;
 	struct tty_ldisc *ld;
-	
+
 	/*
 	 *	Perform the actual termios internal changes under lock.
 	 */
-	 
+
 
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
@@ -400,7 +395,7 @@
 		tty->canon_data = 0;
 		tty->erasing = 0;
 	}
-	
+
 	/* This bit should be in the ldisc code */
 	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
 		/* Get characters left over from canonical mode. */
@@ -423,7 +418,7 @@
 			wake_up_interruptible(&tty->link->read_wait);
 		}
 	}
-	   
+
 	if (tty->driver->set_termios)
 		(*tty->driver->set_termios)(tty, &old_termios);
 	else
@@ -451,7 +446,7 @@
  *		Called functions take ldisc and termios_sem locks
  */
 
-static int set_termios(struct tty_struct * tty, void __user *arg, int opt)
+static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 {
 	struct ktermios tmp_termios;
 	struct tty_ldisc *ld;
@@ -482,19 +477,19 @@
 		return -EFAULT;
 #endif
 
-	/* If old style Bfoo values are used then load c_ispeed/c_ospeed with the real speed
-	   so its unconditionally usable */
+	/* If old style Bfoo values are used then load c_ispeed/c_ospeed
+	 * with the real speed so its unconditionally usable */
 	tmp_termios.c_ispeed = tty_termios_input_baud_rate(&tmp_termios);
 	tmp_termios.c_ospeed = tty_termios_baud_rate(&tmp_termios);
 
 	ld = tty_ldisc_ref(tty);
-	
+
 	if (ld != NULL) {
 		if ((opt & TERMIOS_FLUSH) && ld->flush_buffer)
 			ld->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
-	
+
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
@@ -510,14 +505,14 @@
 	return 0;
 }
 
-static int get_termio(struct tty_struct * tty, struct termio __user * termio)
+static int get_termio(struct tty_struct *tty, struct termio __user *termio)
 {
 	if (kernel_termios_to_user_termio(termio, tty->termios))
 		return -EFAULT;
 	return 0;
 }
 
-static unsigned long inq_canon(struct tty_struct * tty)
+static unsigned long inq_canon(struct tty_struct *tty)
 {
 	int nr, head, tail;
 
@@ -542,7 +537,7 @@
  *
  * The "sg_flags" translation is a joke..
  */
-static int get_sgflags(struct tty_struct * tty)
+static int get_sgflags(struct tty_struct *tty)
 {
 	int flags = 0;
 
@@ -560,7 +555,7 @@
 	return flags;
 }
 
-static int get_sgttyb(struct tty_struct * tty, struct sgttyb __user * sgttyb)
+static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 {
 	struct sgttyb tmp;
 
@@ -571,11 +566,11 @@
 	tmp.sg_kill = tty->termios->c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
 	mutex_unlock(&tty->termios_mutex);
-	
+
 	return copy_to_user(sgttyb, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static void set_sgflags(struct ktermios * termios, int flags)
+static void set_sgflags(struct ktermios *termios, int flags)
 {
 	termios->c_iflag = ICRNL | IXON;
 	termios->c_oflag = 0;
@@ -612,7 +607,7 @@
  *	Locking: termios_sem
  */
 
-static int set_sgttyb(struct tty_struct * tty, struct sgttyb __user * sgttyb)
+static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 {
 	int retval;
 	struct sgttyb tmp;
@@ -621,7 +616,7 @@
 	retval = tty_check_change(tty);
 	if (retval)
 		return retval;
-	
+
 	if (copy_from_user(&tmp, sgttyb, sizeof(tmp)))
 		return -EFAULT;
 
@@ -632,7 +627,8 @@
 	set_sgflags(&termios, tmp.sg_flags);
 	/* Try and encode into Bfoo format */
 #ifdef BOTHER
-	tty_termios_encode_baud_rate(&termios, termios.c_ispeed, termios.c_ospeed);
+	tty_termios_encode_baud_rate(&termios, termios.c_ispeed,
+						termios.c_ospeed);
 #endif
 	mutex_unlock(&tty->termios_mutex);
 	change_termios(tty, &termios);
@@ -641,7 +637,7 @@
 #endif
 
 #ifdef TIOCGETC
-static int get_tchars(struct tty_struct * tty, struct tchars __user * tchars)
+static int get_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 {
 	struct tchars tmp;
 
@@ -654,7 +650,7 @@
 	return copy_to_user(tchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static int set_tchars(struct tty_struct * tty, struct tchars __user * tchars)
+static int set_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 {
 	struct tchars tmp;
 
@@ -671,20 +667,22 @@
 #endif
 
 #ifdef TIOCGLTC
-static int get_ltchars(struct tty_struct * tty, struct ltchars __user * ltchars)
+static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 {
 	struct ltchars tmp;
 
 	tmp.t_suspc = tty->termios->c_cc[VSUSP];
-	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];	/* what is dsuspc anyway? */
+	/* what is dsuspc anyway? */
+	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
 	tmp.t_rprntc = tty->termios->c_cc[VREPRINT];
-	tmp.t_flushc = tty->termios->c_cc[VEOL2];	/* what is flushc anyway? */
+	/* what is flushc anyway? */
+	tmp.t_flushc = tty->termios->c_cc[VEOL2];
 	tmp.t_werasc = tty->termios->c_cc[VWERASE];
 	tmp.t_lnextc = tty->termios->c_cc[VLNEXT];
 	return copy_to_user(ltchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static int set_ltchars(struct tty_struct * tty, struct ltchars __user * ltchars)
+static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 {
 	struct ltchars tmp;
 
@@ -692,9 +690,11 @@
 		return -EFAULT;
 
 	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
-	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;	/* what is dsuspc anyway? */
+	/* what is dsuspc anyway? */
+	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
 	tty->termios->c_cc[VREPRINT] = tmp.t_rprntc;
-	tty->termios->c_cc[VEOL2] = tmp.t_flushc;	/* what is flushc anyway? */
+	/* what is flushc anyway? */
+	tty->termios->c_cc[VEOL2] = tmp.t_flushc;
 	tty->termios->c_cc[VWERASE] = tmp.t_werasc;
 	tty->termios->c_cc[VLNEXT] = tmp.t_lnextc;
 	return 0;
@@ -742,10 +742,10 @@
  *	consistent mode setting.
  */
 
-int tty_mode_ioctl(struct tty_struct * tty, struct file *file,
+int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct * real_tty;
+	struct tty_struct *real_tty;
 	void __user *p = (void __user *)arg;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -756,100 +756,100 @@
 
 	switch (cmd) {
 #ifdef TIOCGETP
-		case TIOCGETP:
-			return get_sgttyb(real_tty, (struct sgttyb __user *) arg);
-		case TIOCSETP:
-		case TIOCSETN:
-			return set_sgttyb(real_tty, (struct sgttyb __user *) arg);
+	case TIOCGETP:
+		return get_sgttyb(real_tty, (struct sgttyb __user *) arg);
+	case TIOCSETP:
+	case TIOCSETN:
+		return set_sgttyb(real_tty, (struct sgttyb __user *) arg);
 #endif
 #ifdef TIOCGETC
-		case TIOCGETC:
-			return get_tchars(real_tty, p);
-		case TIOCSETC:
-			return set_tchars(real_tty, p);
+	case TIOCGETC:
+		return get_tchars(real_tty, p);
+	case TIOCSETC:
+		return set_tchars(real_tty, p);
 #endif
 #ifdef TIOCGLTC
-		case TIOCGLTC:
-			return get_ltchars(real_tty, p);
-		case TIOCSLTC:
-			return set_ltchars(real_tty, p);
-#endif
-		case TCSETSF:
-			return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT | TERMIOS_OLD);
-		case TCSETSW:
-			return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_OLD);
-		case TCSETS:
-			return set_termios(real_tty, p, TERMIOS_OLD);
+	case TIOCGLTC:
+		return get_ltchars(real_tty, p);
+	case TIOCSLTC:
+		return set_ltchars(real_tty, p);
+#endif
+	case TCSETSF:
+		return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT | TERMIOS_OLD);
+	case TCSETSW:
+		return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_OLD);
+	case TCSETS:
+		return set_termios(real_tty, p, TERMIOS_OLD);
 #ifndef TCGETS2
-		case TCGETS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
-				return -EFAULT;
-			return 0;
+	case TCGETS:
+		if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
+			return -EFAULT;
+		return 0;
 #else
-		case TCGETS:
-			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios))
-				return -EFAULT;
-			return 0;
-		case TCGETS2:
-			if (kernel_termios_to_user_termios((struct termios2 __user *)arg, real_tty->termios))
-				return -EFAULT;
-			return 0;
-		case TCSETSF2:
-			return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT);
-		case TCSETSW2:
-			return set_termios(real_tty, p, TERMIOS_WAIT);
-		case TCSETS2:
-			return set_termios(real_tty, p, 0);
-#endif
-		case TCGETA:
-			return get_termio(real_tty, p);
-		case TCSETAF:
-			return set_termios(real_tty, p, TERMIOS_FLUSH | TERMIOS_WAIT | TERMIOS_TERMIO);
-		case TCSETAW:
-			return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_TERMIO);
-		case TCSETA:
-			return set_termios(real_tty, p, TERMIOS_TERMIO);
+	case TCGETS:
+		if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios))
+			return -EFAULT;
+		return 0;
+	case TCGETS2:
+		if (kernel_termios_to_user_termios((struct termios2 __user *)arg, real_tty->termios))
+			return -EFAULT;
+		return 0;
+	case TCSETSF2:
+		return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT);
+	case TCSETSW2:
+		return set_termios(real_tty, p, TERMIOS_WAIT);
+	case TCSETS2:
+		return set_termios(real_tty, p, 0);
+#endif
+	case TCGETA:
+		return get_termio(real_tty, p);
+	case TCSETAF:
+		return set_termios(real_tty, p, TERMIOS_FLUSH | TERMIOS_WAIT | TERMIOS_TERMIO);
+	case TCSETAW:
+		return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_TERMIO);
+	case TCSETA:
+		return set_termios(real_tty, p, TERMIOS_TERMIO);
 #ifndef TCGETS2
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
-			return 0;
+	case TIOCGLCKTRMIOS:
+		if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+			return -EFAULT;
+		return 0;
+	case TIOCSLCKTRMIOS:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (user_termios_to_kernel_termios(real_tty->termios_locked,
+					       (struct termios __user *) arg))
+			return -EFAULT;
+		return 0;
 #else
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
+	case TIOCGLCKTRMIOS:
+		if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
+			return -EFAULT;
+		return 0;
+	case TIOCSLCKTRMIOS:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (user_termios_to_kernel_termios_1(real_tty->termios_locked,
+					       (struct termios __user *) arg))
+			return -EFAULT;
 			return 0;
 #endif
-		case TIOCGSOFTCAR:
-			return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)arg);
-		case TIOCSSOFTCAR:
-			if (get_user(arg, (unsigned int __user *) arg))
-				return -EFAULT;
-			mutex_lock(&tty->termios_mutex);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			mutex_unlock(&tty->termios_mutex);
-			return 0;
-		default:
-			return -ENOIOCTLCMD;
+	case TIOCGSOFTCAR:
+		return put_user(C_CLOCAL(tty) ? 1 : 0,
+						(int __user *)arg);
+	case TIOCSSOFTCAR:
+		if (get_user(arg, (unsigned int __user *) arg))
+			return -EFAULT;
+		mutex_lock(&tty->termios_mutex);
+		tty->termios->c_cflag =
+			((tty->termios->c_cflag & ~CLOCAL) |
+			 (arg ? CLOCAL : 0));
+		mutex_unlock(&tty->termios_mutex);
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
 	}
 }
-
 EXPORT_SYMBOL_GPL(tty_mode_ioctl);
 
 int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
@@ -880,13 +880,12 @@
 	tty_ldisc_deref(ld);
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tty_perform_flush);
 
-int n_tty_ioctl(struct tty_struct * tty, struct file * file,
+int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct * real_tty;
+	struct tty_struct *real_tty;
 	int retval;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -896,68 +895,67 @@
 		real_tty = tty;
 
 	switch (cmd) {
-		case TCXONC:
-			retval = tty_check_change(tty);
-			if (retval)
-				return retval;
-			switch (arg) {
-			case TCOOFF:
-				if (!tty->flow_stopped) {
-					tty->flow_stopped = 1;
-					stop_tty(tty);
-				}
-				break;
-			case TCOON:
-				if (tty->flow_stopped) {
-					tty->flow_stopped = 0;
-					start_tty(tty);
-				}
-				break;
-			case TCIOFF:
-				if (STOP_CHAR(tty) != __DISABLED_CHAR)
-					return send_prio_char(tty, STOP_CHAR(tty));
-				break;
-			case TCION:
-				if (START_CHAR(tty) != __DISABLED_CHAR)
-					return send_prio_char(tty, START_CHAR(tty));
-				break;
-			default:
-				return -EINVAL;
+	case TCXONC:
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
+		switch (arg) {
+		case TCOOFF:
+			if (!tty->flow_stopped) {
+				tty->flow_stopped = 1;
+				stop_tty(tty);
 			}
-			return 0;
-		case TCFLSH:
-			return tty_perform_flush(tty, arg);
-		case TIOCOUTQ:
-			return put_user(tty->driver->chars_in_buffer ?
-					tty->driver->chars_in_buffer(tty) : 0,
-					(int __user *) arg);
-		case TIOCINQ:
-			retval = tty->read_cnt;
-			if (L_ICANON(tty))
-				retval = inq_canon(tty);
-			return put_user(retval, (unsigned int __user *) arg);
-		case TIOCPKT:
-		{
-			int pktmode;
-
-			if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
-			    tty->driver->subtype != PTY_TYPE_MASTER)
-				return -ENOTTY;
-			if (get_user(pktmode, (int __user *) arg))
-				return -EFAULT;
-			if (pktmode) {
-				if (!tty->packet) {
-					tty->packet = 1;
-					tty->link->ctrl_status = 0;
-				}
-			} else
-				tty->packet = 0;
-			return 0;
-		}
+			break;
+		case TCOON:
+			if (tty->flow_stopped) {
+				tty->flow_stopped = 0;
+				start_tty(tty);
+			}
+			break;
+		case TCIOFF:
+			if (STOP_CHAR(tty) != __DISABLED_CHAR)
+				return send_prio_char(tty, STOP_CHAR(tty));
+			break;
+		case TCION:
+			if (START_CHAR(tty) != __DISABLED_CHAR)
+				return send_prio_char(tty, START_CHAR(tty));
+			break;
 		default:
-			/* Try the mode commands */
-			return tty_mode_ioctl(tty, file, cmd, arg);
+			return -EINVAL;
 		}
+		return 0;
+	case TCFLSH:
+		return tty_perform_flush(tty, arg);
+	case TIOCOUTQ:
+		return put_user(tty->driver->chars_in_buffer ?
+				tty->driver->chars_in_buffer(tty) : 0,
+				(int __user *) arg);
+	case TIOCINQ:
+		retval = tty->read_cnt;
+		if (L_ICANON(tty))
+			retval = inq_canon(tty);
+		return put_user(retval, (unsigned int __user *) arg);
+	case TIOCPKT:
+	{
+		int pktmode;
+
+		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
+		    tty->driver->subtype != PTY_TYPE_MASTER)
+			return -ENOTTY;
+		if (get_user(pktmode, (int __user *) arg))
+			return -EFAULT;
+		if (pktmode) {
+			if (!tty->packet) {
+				tty->packet = 1;
+				tty->link->ctrl_status = 0;
+			}
+		} else
+			tty->packet = 0;
+		return 0;
+	}
+	default:
+		/* Try the mode commands */
+		return tty_mode_ioctl(tty, file, cmd, arg);
+	}
 }
-
 EXPORT_SYMBOL(n_tty_ioctl);
