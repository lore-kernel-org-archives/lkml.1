Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYJUMs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYJUMs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYJUMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:48:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45167 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753196AbYJUMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:48:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix tty_port kref screwup
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2008 13:47:44 +0100
Message-ID: <20081021124744.5039.7837.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Pass the brown paper bags please. I changed the semantics of this so the
function was supposed to do the extra kref itself then forgot to do the
change.. duh....

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 553b0e9..c8f8024 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -90,7 +90,7 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
 	spin_lock_irqsave(&port->lock, flags);
 	if (port->tty)
 		tty_kref_put(port->tty);
-	port->tty = tty;
+	port->tty = tty_kref_get(tty);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 EXPORT_SYMBOL(tty_port_tty_set);

