Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbZLKX3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbZLKX3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbZLKX3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:01 -0500
Received: from kroah.org ([198.145.64.141]:50409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762669AbZLKX2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <scottk@digi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/58] jsm: Rewriting a bad log message
Date: Fri, 11 Dec 2009 15:27:46 -0800
Message-Id: <1260574122-10676-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Actually jsm displays "Device Added" 8 times (for a 8 port device).
This silly patch just makes things more informative, showing
the port (instead of the device) that was added.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/jsm/jsm_tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 7439c03..6423dfb 100644
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
1.6.5.5

