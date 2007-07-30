Return-Path: <linux-kernel-owner+w=401wt.eu-S966141AbXG3Cgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966141AbXG3Cgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966018AbXG3Cfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:35:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004AbXG3Cfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:35:41 -0400
From: Satyam Sharma <satyam@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Date: Mon, 30 Jul 2007 08:18:01 +0530
Message-Id: <20070730024801.10828.79291.sendpatchset@enigma.security.iitk.ac.in>
In-Reply-To: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
References: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
Subject: [PATCH v3 -mm 2/9] netconsole: Remove bogus check
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <satyam@infradead.org>

[2/9] netconsole: Remove bogus check

The (!np.dev) check in write_msg() is bogus (always false), because:
np.dev is set by netpoll_setup(), which is called by init_netconsole()
before register_console(), so write_msg() cannot be triggered unless
netpoll_setup() successfully set np.dev. Also np.dev cannot go away
from under us, because netpoll_setup() grabs us reference on it. So
let's remove the bogus check.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>

---

 drivers/net/netconsole.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index f1c2a2d..2c2aef1 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -67,9 +67,6 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 	int frag, left;
 	unsigned long flags;
 
-	if (!np.dev)
-		return;
-
 	local_irq_save(flags);
 
 	for (left = len; left;) {
