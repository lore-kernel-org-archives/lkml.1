Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXDDVpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXDDVpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXDDVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:45:54 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:25012 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXDDVpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:45:52 -0400
Message-id: <318322719957835625@karneval.cz>
In-reply-to: <16309194841640222796@karneval.cz>
Subject: [PATCH 5/5] Char: cyclades, remove useless casts
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed,  4 Apr 2007 23:45:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove useless casts

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 68c91f59163a6536a2f445a14b0c47ea16b41faa
tree a06734e9113b7bc10aa7f8b3e87c3d58780e7125
parent fc6aa32bd302fb7dbd1dcc7c5829b0cb27a79ce6
author Jiri Slaby <jirislaby@gmail.com> Mon, 26 Mar 2007 18:16:13 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 27 Mar 2007 14:45:42 +0200

 drivers/char/cyclades.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 70d5a39..abdc3c7 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2636,7 +2636,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
  */
 static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
 	unsigned long orig_jiffies;
@@ -2713,7 +2713,7 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
  */
 static void cy_close(struct tty_struct *tty, struct file *filp)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
@@ -2858,7 +2858,7 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
  */
 static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	int c, ret = 0;
 
@@ -2909,7 +2909,7 @@ static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
  */
 static void cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
@@ -2942,7 +2942,7 @@ static void cy_put_char(struct tty_struct *tty, unsigned char ch)
  */
 static void cy_flush_chars(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_IO
 	printk("cyc:cy_flush_chars ttyC%d\n", info->line);	/* */
@@ -2966,7 +2966,7 @@ static void cy_flush_chars(struct tty_struct *tty)
  */
 static int cy_write_room(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int ret;
 
 #ifdef CY_DEBUG_IO
@@ -2983,7 +2983,7 @@ static int cy_write_room(struct tty_struct *tty)
 
 static int cy_chars_in_buffer(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_chars_in_buffer"))
@@ -3572,7 +3572,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user * value)
 
 static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
@@ -3646,7 +3646,7 @@ static int
 cy_tiocmset(struct tty_struct *tty, struct file *file,
 		unsigned int set, unsigned int clear)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
@@ -3797,7 +3797,7 @@ cy_tiocmset(struct tty_struct *tty, struct file *file,
  */
 static void cy_break(struct tty_struct *tty, int break_state)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "cy_break"))
@@ -3997,7 +3997,7 @@ static int
 cy_ioctl(struct tty_struct *tty, struct file *file,
 	 unsigned int cmd, unsigned long arg)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_icount cprev, cnow;	/* kernel counter temps */
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	int ret_val = 0;
@@ -4190,7 +4190,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
  */
 static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
 	printk("cyc:cy_set_termios ttyC%d\n", info->line);
@@ -4225,7 +4225,7 @@ static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 */
 static void cy_send_xchar(struct tty_struct *tty, char ch)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_send_xchar"))
@@ -4255,7 +4255,7 @@ static void cy_send_xchar(struct tty_struct *tty, char ch)
  */
 static void cy_throttle(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
@@ -4313,7 +4313,7 @@ static void cy_throttle(struct tty_struct *tty)
  */
 static void cy_unthrottle(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
 	void __iomem *base_addr;
 	int card, chip, channel, index;
@@ -4369,7 +4369,7 @@ static void cy_unthrottle(struct tty_struct *tty)
 static void cy_stop(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned long flags;
@@ -4404,7 +4404,7 @@ static void cy_stop(struct tty_struct *tty)
 static void cy_start(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned long flags;
@@ -4437,7 +4437,7 @@ static void cy_start(struct tty_struct *tty)
 
 static void cy_flush_buffer(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 	int card, channel, retval;
 	unsigned long flags;
 
@@ -4474,7 +4474,7 @@ static void cy_flush_buffer(struct tty_struct *tty)
  */
 static void cy_hangup(struct tty_struct *tty)
 {
-	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
 	printk("cyc:cy_hangup ttyC%d\n", info->line);	/* */
