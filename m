Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZI3QTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZI3QTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZI3QTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:19:41 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:39957 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZI3QTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:19:41 -0400
From: leitao@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] jsm: fixing termios structure to be compatible with stty application
Date: Wed, 30 Sep 2009 12:18:32 -0400
Message-Id: <1254327512-6880-1-git-send-email-leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently stty returns "unable to perform all requested operations",
when it changes the speed of a jsm device.
It was happening because c_ispeed and c_ospeed were not set properly.
This patch just set them, so that when stty compare the requested
and the new mode(struct termios), they are the same.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm_tty.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 00f4577..dd1ed76 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -321,6 +321,10 @@ static void jsm_tty_set_termios(struct uart_port *port,
 
 	channel->ch_bd->bd_ops->param(channel);
 	jsm_carrier(channel);
+
+	termios->c_ispeed = termios->c_cflag & CBAUD;
+	termios->c_ospeed = termios->c_cflag & CBAUD;
+
 	spin_unlock_irqrestore(&port->lock, lock_flags);
 }
 
-- 
1.6.0.2

