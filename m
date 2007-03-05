Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbXCEBuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbXCEBuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXCEBtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:53 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49950 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbXCEBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:45 -0500
Date: Mon, 5 Mar 2007 02:49:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/video/hecubafb.c: make 4 functions static
Message-ID: <20070305014945.GB3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
> +fbdev-hecuba-framebuffer-driver.patch
>...
>  fbdev updates
>...


This patch makes the following needlessly global functions static:
- hcb_wait_for_ack()
- hcb_wait_for_ack_clear()
- apollo_send_data()
- apollo_send_command()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/hecubafb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.21-rc2-mm1/drivers/video/hecubafb.c.old	2007-03-04 21:57:45.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/video/hecubafb.c	2007-03-04 21:58:30.000000000 +0100
@@ -145,7 +145,7 @@
 	return 0;
 }
 
-void hcb_wait_for_ack(struct hecubafb_par *par)
+static void hcb_wait_for_ack(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -161,7 +161,7 @@
 	printk(KERN_ERR "timed out waiting for ack\n");
 }
 
-void hcb_wait_for_ack_clear(struct hecubafb_par *par)
+static void hcb_wait_for_ack_clear(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -177,7 +177,7 @@
 	printk(KERN_ERR "timed out waiting for clear\n");
 }
 
-void apollo_send_data(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_data(struct hecubafb_par *par, unsigned char data)
 {
 	/* set data */
 	hcb_set_data(par, data);
@@ -195,7 +195,7 @@
 	hcb_wait_for_ack_clear(par);
 }
 
-void apollo_send_command(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_command(struct hecubafb_par *par, unsigned char data)
 {
 	/* command so set CD to high */
 	par->ctl &= ~(HCB_NCD_BIT);

