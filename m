Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYE2PkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYE2PkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYE2PkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:40:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54406 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbYE2PkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:40:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] [PATCH] removed unused var real_tty on n_tty_ioctl()
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 16:26:00 +0100
Message-ID: <20080529152559.24079.81146.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

From: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>

Hello,

I noted that the 'struct tty_struct *real_tty' is not used in this
function, so I removed the code about 'real_tty'. This little change
is on kernel 2.6.25.4, but aplies on 2.6.24 or greater.

Signed-off-by: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_ioctl.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)


diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index b1a757a..8f81139 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -981,16 +981,9 @@ EXPORT_SYMBOL_GPL(tty_perform_flush);
 int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct *real_tty;
 	unsigned long flags;
 	int retval;
 
-	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
-	    tty->driver->subtype == PTY_TYPE_MASTER)
-		real_tty = tty->link;
-	else
-		real_tty = tty;
-
 	switch (cmd) {
 	case TCXONC:
 		retval = tty_check_change(tty);

