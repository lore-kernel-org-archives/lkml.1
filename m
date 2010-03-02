Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0CBJrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:47:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:30610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0CBJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=s7kHirY/+wozxCw57GpYOKwGPCNdZWdo4FZ02SR0XAwk6f36uOQzsMQJpJ7IMGCTUT
         iirsZ/hjQvMgk0vq7m6n49jrVjEeg575pZf43kXcxlMdIIKbkQc/UlbxixA0GsRa9Jux
         cI4nOJKBvBkLU80Ji4IcXN3eVXxXE2F6Dd1Yc=
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 10:47:09 +0100
X-Google-Sender-Auth: 6476a44784031bb7
Message-ID: <29b3a6721003020147k1eb0d7e9v7bc3c85cd21895cd@mail.gmail.com>
Subject: [PATCH] drivers: bluetooth: hci_ldisc: Fixed multiple coding style 
	issues
From: Romain Guillebert <romain.py@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes many coding style issues in this file

Signed-off-by: Romain Guillebert <romain.py@gmail.com>
---
 drivers/bluetooth/hci_ldisc.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index aa09193..6aa1c25 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -48,7 +48,7 @@

 #define VERSION "2.2"

-static int reset = 0;
+static int reset;

 static struct hci_uart_proto *hup[HCI_UART_MAX_PROTO];

@@ -244,12 +244,12 @@ static void hci_uart_destruct(struct hci_dev *hdev)

 /* ------ LDISC part ------ */
 /* hci_uart_tty_open
- *
+ *
  *     Called when line discipline changed to HCI_UART.
  *
  * Arguments:
  *     tty    pointer to tty info structure
- * Return Value:
+ * Return Value:
  *     0 if success, otherwise error code
  */
 static int hci_uart_tty_open(struct tty_struct *tty)
@@ -261,7 +261,8 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	if (hu)
 		return -EEXIST;

-	if (!(hu = kzalloc(sizeof(struct hci_uart), GFP_KERNEL))) {
+	hu = kzalloc(sizeof(struct hci_uart), GFP_KERNEL);
+	if (!hu) {
 		BT_ERR("Can't allocate control structure");
 		return -ENFILE;
 	}
@@ -339,15 +340,15 @@ static void hci_uart_tty_wakeup(struct tty_struct *tty)
 }

 /* hci_uart_tty_receive()
- *
+ *
  *     Called by tty low level driver when receive data is
  *     available.
- *
+ *
  * Arguments:  tty          pointer to tty isntance data
  *             data         pointer to received data
  *             flags        pointer to flags for data
  *             count        count of received data in bytes
- *
+ *
  * Return Value:    None
  */
 static void hci_uart_tty_receive(struct tty_struct *tty, const u8
*data, char *flags, int count)
@@ -515,7 +516,7 @@ static int __init hci_uart_init(void)

 	/* Register the tty discipline */

-	memset(&hci_uart_ldisc, 0, sizeof (hci_uart_ldisc));
+	memset(&hci_uart_ldisc, 0, sizeof(hci_uart_ldisc));
 	hci_uart_ldisc.magic		= TTY_LDISC_MAGIC;
 	hci_uart_ldisc.name		= "n_hci";
 	hci_uart_ldisc.open		= hci_uart_tty_open;
@@ -528,7 +529,8 @@ static int __init hci_uart_init(void)
 	hci_uart_ldisc.write_wakeup	= hci_uart_tty_wakeup;
 	hci_uart_ldisc.owner		= THIS_MODULE;

-	if ((err = tty_register_ldisc(N_HCI, &hci_uart_ldisc))) {
+	err = tty_register_ldisc(N_HCI, &hci_uart_ldisc);
+	if (err) {
 		BT_ERR("HCI line discipline registration failed. (%d)", err);
 		return err;
 	}
@@ -561,7 +563,8 @@ static void __exit hci_uart_exit(void)
 #endif

 	/* Release tty registration of line discipline */
-	if ((err = tty_unregister_ldisc(N_HCI)))
+	err = tty_unregister_ldisc(N_HCI);
+	if (err)
 		BT_ERR("Can't unregister HCI line discipline (%d)", err);
 }

-- 
1.7.0
