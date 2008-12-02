Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYLBVVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYLBVVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLBVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:21:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:33097 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYLBVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=v+k6Fm2FIE+4HlI8l8Y0R0XNusYE+BX9iTcwI4I79Jic0FHAv+wd1tSHvo5VSkywaH
         VYB595j2QMBYoDbgm/Sq6M3uTqhYEMKXwDi1U88470EF7g1pSspffS6pMMtO/osY5DWe
         ACgOcPOFFk8uf09+1dIwUdcQwJYrqvBJ/t+EI=
Message-ID: <4935A6E7.3070704@gmail.com>
Date: Tue, 02 Dec 2008 22:21:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: paulus@samba.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] hv{c,cs,si}_struct make *count signed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise count < 0 will fail

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This was not tested. Is this how it should be fixed?

the locations where the failures occur are in the functions hv*_close, on:

vi drivers/char/hvcs.c +1251

vi drivers/char/hvsi.c +911

vi drivers/char/drivers/char/hvc_console.c +387

diff --git a/drivers/char/hvc_console.h b/drivers/char/hvc_console.h
index 8297dbc..3c85d78 100644
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -48,7 +48,7 @@ struct hvc_struct {
 	spinlock_t lock;
 	int index;
 	struct tty_struct *tty;
-	unsigned int count;
+	int count;
 	int do_wakeup;
 	char *outbuf;
 	int outbuf_size;
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 473d9b1..6e6eb44 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -269,7 +269,7 @@ struct hvcs_struct {
 	unsigned int index;
 
 	struct tty_struct *tty;
-	unsigned int open_count;
+	int open_count;
 
 	/*
 	 * Used to tell the driver kernel_thread what operations need to take
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 59c6f9a..af05528 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -75,7 +75,7 @@ struct hvsi_struct {
 	spinlock_t lock;
 	int index;
 	struct tty_struct *tty;
-	unsigned int count;
+	int count;
 	uint8_t throttle_buf[128];
 	uint8_t outbuf[N_OUTBUF]; /* to implement write_room and chars_in_buffer */
 	/* inbuf is for packet reassembly. leave a little room for leftovers. */
