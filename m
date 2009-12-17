Return-Path: <linux-kernel-owner+w=401wt.eu-S935968AbZLQB3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968AbZLQB3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763655AbZLQBUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:48 -0500
Received: from kroah.org ([198.145.64.141]:48074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763665AbZLQBUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.824429156@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [60/90] sunsu: Fix detection of SU ports which are RSC console or control.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8301d386afc55c877bafe2c6c7dc75a96ddd2838 ]

These device nodes are named "rsc-console" and "rsc-control" rather
than 'serial', but the device_type property is 'serial' so we'll
tip off of that for detection.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/sunsu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1517,6 +1517,10 @@ static const struct of_device_id su_matc
 		.name = "serial",
 		.compatible = "su",
 	},
+	{
+		.type = "serial",
+		.compatible = "su",
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, su_match);
@@ -1548,6 +1552,12 @@ static int __init sunsu_init(void)
 				num_uart++;
 		}
 	}
+	for_each_node_by_type(dp, "serial") {
+		if (of_device_is_compatible(dp, "su")) {
+			if (su_get_type(dp) == SU_PORT_PORT)
+				num_uart++;
+		}
+	}
 
 	if (num_uart) {
 		err = sunserial_register_minors(&sunsu_reg, num_uart);


