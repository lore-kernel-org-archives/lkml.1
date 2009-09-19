Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZISVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZISVlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZISVl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:27 -0400
Received: from kroah.org ([198.145.64.141]:40459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbZISVlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/79] cdc_acm: Fix to use modern speed interfaces
Date: Sat, 19 Sep 2009 14:36:41 -0700
Message-Id: <1253396244-7885-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This changed in 2006 so its about time the ACM driver caught up

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/class/cdc-acm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 2bfc41e..85a1a55 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -858,10 +858,7 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 	if (!ACM_READY(acm))
 		return;
 
-	/* FIXME: Needs to support the tty_baud interface */
-	/* FIXME: Broken on sparc */
-	newline.dwDTERate = cpu_to_le32p(acm_tty_speed +
-		(termios->c_cflag & CBAUD & ~CBAUDEX) + (termios->c_cflag & CBAUDEX ? 15 : 0));
+	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
 	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
 	newline.bParityType = termios->c_cflag & PARENB ?
 				(termios->c_cflag & PARODD ? 1 : 2) +
-- 
1.6.4.2

