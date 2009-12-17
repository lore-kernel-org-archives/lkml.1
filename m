Return-Path: <linux-kernel-owner+w=401wt.eu-S936001AbZLQBb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936001AbZLQBb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935538AbZLQBbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:31:18 -0500
Received: from kroah.org ([198.145.64.141]:48077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763644AbZLQBUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.209811936@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [63/90] sunsu: Pass true ignore_line to console match when RSC or LOM console.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 1917d17b903955b8b2903626a2e01d071a5d0ec9 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/sunsu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1409,6 +1409,7 @@ static int __devinit su_probe(struct of_
 	struct uart_sunsu_port *up;
 	struct resource *rp;
 	enum su_type type;
+	bool ignore_line;
 	int err;
 
 	type = su_get_type(dp);
@@ -1467,9 +1468,14 @@ static int __devinit su_probe(struct of_
 
 	up->port.ops = &sunsu_pops;
 
+	ignore_line = false;
+	if (!strcmp(dp->name, "rsc-console") ||
+	    !strcmp(dp->name, "lom-console"))
+		ignore_line = true;
+
 	sunserial_console_match(SUNSU_CONSOLE(), dp,
 				&sunsu_reg, up->port.line,
-				false);
+				ignore_line);
 	err = uart_add_one_port(&sunsu_reg, &up->port);
 	if (err)
 		goto out_unmap;


