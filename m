Return-Path: <linux-kernel-owner+w=401wt.eu-S1765193AbYDVTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765193AbYDVTyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbYDVTxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:53:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45067 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763017AbYDVTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:53:07 -0400
Date: Tue, 22 Apr 2008 16:02:03 -0300
From: Leonardo Chiquitto <leonardo@iken.com.br>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] airprime: unlock mutex instead of trying to lock it again
Message-ID: <20080422190155.GA11353@libre.l.ngdn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patch fixes a [probable] copy & paste mistake in
airprime.c. Instead of unlocking an acquired mutex, the actual
code tries to lock it again.

Signed-off-by: Leonardo Chiquitto <lchiquitto@novell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
Leonardo


Index: kernel/drivers/usb/serial/airprime.c
===================================================================
--- kernel.orig/drivers/usb/serial/airprime.c
+++ kernel/drivers/usb/serial/airprime.c
@@ -220,7 +220,7 @@ static void airprime_close(struct usb_se
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected)
 		airprime_send_setup(port);
-	mutex_lock(&port->serial->disc_mutex);
+	mutex_unlock(&port->serial->disc_mutex);
 
 	for (i = 0; i < NUM_READ_URBS; ++i) {
 		usb_kill_urb (priv->read_urbp[i]);
