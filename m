Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZFXVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZFXVdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZFXVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:33:34 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:54936 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZFXVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:33:33 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@suse.de, linux-usb@vger.kernel.org,
       oliver@neukum.name,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/3] Return ENODEV instead of EINVAL when trying to open ACM device.
Date: Wed, 24 Jun 2009 18:33:29 -0300
Message-Id: <1245879211-10130-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required, otherwise a user will get a EINVAL while opening a
non-existing device, instead of ENODEV.

This is what I get with this patch applied now instead of an "Invalid
argument".

cascardo@vespa:~$ cat /dev/ttyACM0
cat: /dev/ttyACM0: No such device
cascardo@vespa:~$

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 38bfdb0..02eb60b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -550,7 +550,7 @@ static void acm_waker(struct work_struct *waker)
 static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 {
 	struct acm *acm;
-	int rv = -EINVAL;
+	int rv = -ENODEV;
 	int i;
 	dbg("Entering acm_tty_open.");
 
-- 
1.6.3

