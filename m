Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbXA3BN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbXA3BN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXA3BMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:12:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47393 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbXA3BLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:51 -0500
Date: Tue, 30 Jan 2007 02:11:59 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/char/pcmcia/ipwireless_cs_*: possible cleanups
Message-ID: <20070130011159.GE3754@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 11:49:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc4-mm1:
>...
>  git-ipwireless_cs.patch
>...
>  git trees.
>...

This patch contains the following possible cleanups:
- proper prototypes for global functions in header files
- make the following needlessly global function static:
  - ipwireless_cs_hardware.c: data_type()
- make the following needlessly global struct static:
  - ipwireless_cs_tty.c: ipw_tty_driver
- #if 0 the following unused global functions:
  - ipwireless_cs_hardware.c: ipwireless_get_config()
  - ipwireless_cs_tty.c: ipw_flush_buffer()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/char/pcmcia/ipwireless_cs_hardware.c |    4 +++-
 drivers/char/pcmcia/ipwireless_cs_hardware.h |    5 ++---
 drivers/char/pcmcia/ipwireless_cs_network.h  |    2 ++
 drivers/char/pcmcia/ipwireless_cs_tty.c      |   10 +++-------
 4 files changed, 10 insertions(+), 11 deletions(-)

--- linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_network.h.old	2007-01-29 00:17:28.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_network.h	2007-01-29 00:17:56.000000000 +0100
@@ -43,4 +43,6 @@
 int ipwireless_ppp_channel_index(struct ipw_network_t *);
 int ipwireless_ppp_unit_number(struct ipw_network_t *);
 
+int ipwireless_dump_network_state(char *p, struct ipw_network_t *network);
+
 #endif
--- linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_hardware.h.old	2007-01-29 00:20:14.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_hardware.h	2007-01-29 00:16:54.000000000 +0100
@@ -43,9 +43,6 @@
 			    unsigned int, ipw_packet_sent_callback_t,
 			    void *);
 
-/* Get the configuration settings for this modem instance. */
-struct ipw_config_t *ipwireless_get_config(struct ipw_hardware_t *);
-
 /* Associate the specified network with this hardware */
 void ipwireless_associate_network(struct ipw_hardware_t *, struct ipw_network_t *);
 
@@ -64,4 +61,6 @@
 
 void ipwireless_sleep(u_int tenths);
 
+int ipwireless_dump_hardware_state(char *p, struct ipw_hardware_t *hw);
+
 #endif
--- linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_hardware.c.old	2007-01-28 23:34:55.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_hardware.c	2007-01-28 23:36:26.000000000 +0100
@@ -375,7 +375,7 @@
 
 
 
-char *data_type(const u_char * buf, unsigned length)
+static char *data_type(const u_char * buf, unsigned length)
 {
 	NLPacketHeader *hdr = (NLPacketHeader *) buf;
 	if (length == 0)
@@ -1592,10 +1592,12 @@
 	kfree(hw);
 }
 
+#if 0
 ipw_config_t *ipwireless_get_config(struct ipw_hardware_t *hw)
 {
 	return &hw->config;
 }
+#endif  /*  0  */
 
 /* Associate the specified network with this hardware, so it will receive events
  * from it. */
--- linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_tty.c.old	2007-01-28 23:36:46.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/char/pcmcia/ipwireless_cs_tty.c	2007-01-29 00:18:02.000000000 +0100
@@ -463,10 +463,12 @@
 	return ppp_ioctl(linux_tty, file, cmd, arg);
 }
 
+#if 0
 void ipw_flush_buffer(struct tty_struct *tty)
 {
 	wake_up_interruptible(&tty->write_wait);
 }
+#endif  /*  0  */
 
 static void add_tty(int first, int *j, dev_node_t ** nodesp,
 		    struct pcmcia_device *link,
@@ -578,7 +580,7 @@
 	.tiocmset = ipw_tiocmset,
 };
 
-struct tty_driver *ipw_tty_driver;
+static struct tty_driver *ipw_tty_driver;
 
 static int proc_read(char *page, char **start, off_t off, int count,
 		     int *eof, void *data)
@@ -586,12 +588,6 @@
 	int i, j;
 	char *p = page;
 	int len;
-#ifdef IPWIRELESS_STATE_DEBUG
-	int ipwireless_dump_hardware_state(char *p,
-					   struct ipw_hardware_t *hw);
-	int ipwireless_dump_network_state(char *p,
-					  struct ipw_network_t *network);
-#endif
 
 	if (off == 0) {
 		p += sprintf(p, "driver: %s\nversion: %s\n\n",

