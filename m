Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZIXT6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZIXT6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZIXT6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:58:34 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:58172 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZIXT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:58:25 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, scottk@digi.com
Subject: [PATCH 2/2] jsm: Rewriting a bad log message
Date: Thu, 24 Sep 2009 16:58:23 -0300
Message-Id: <b37337c10bf763c5d64071301b45a2089e97897f.1253820690.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <39629f59067510a052f4a493be9044a572de7f15.1253820690.git.leitao@linux.vnet.ibm.com>
References: <39629f59067510a052f4a493be9044a572de7f15.1253820690.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1253820690.git.leitao@linux.vnet.ibm.com>
References: <cover.1253820690.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually jsm displays "Device Added" 8 times (for a 8 port device).
This silly patch just makes things more informative, showing
the port (instead of the device) that was added.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm_tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 00f4577..dd19ef9 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -472,7 +472,7 @@ int __devinit jsm_uart_port_init(struct jsm_board *brd)
 		if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
 			printk(KERN_INFO "jsm: add device failed\n");
 		else
-			printk(KERN_INFO "Added device \n");
+			printk(KERN_INFO "jsm: Port %d added\n", i);
 	}
 
 	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
-- 
1.6.0.4

