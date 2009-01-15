Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbZAONca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbZAONca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764941AbZAONa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60788 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764931AbZAONa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/8] tty: Fix a kref leak in the HSO driver on re-open
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:31:15 +0000
Message-ID: <20090115133112.21366.14262.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/net/usb/hso.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index c4918b8..9df04dd 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1297,6 +1297,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	/* setup */
 	spin_lock_irq(&serial->serial_lock);
 	tty->driver_data = serial;
+	tty_kref_put(serial->tty);
 	serial->tty = tty_kref_get(tty);
 	spin_unlock_irq(&serial->serial_lock);
 

