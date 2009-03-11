Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZCKUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZCKUA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCKUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:00:16 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43746 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCKUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:00:15 -0400
Message-ID: <49B81849.7090908@linux.vnet.ibm.com>
Date: Wed, 11 Mar 2009 17:00:09 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: scottk@digi.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 1/1] jsm: Defining init function as __devinit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defining init functions as __devinit

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm_driver.c |    2 +-
 drivers/serial/jsm/jsm_tty.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index ac79cbe..576aafb 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -52,7 +52,7 @@ int jsm_debug;
 module_param(jsm_debug, int, 0);
 MODULE_PARM_DESC(jsm_debug, "Driver debugging level");
 
-static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc = 0;
 	struct jsm_board *brd;
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 324c74d..3306963 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -367,7 +367,7 @@ static struct uart_ops jsm_ops = {
  * Init the tty subsystem.  Called once per board after board has been
  * downloaded and init'ed.
  */
-int jsm_tty_init(struct jsm_board *brd)
+int __devinit jsm_tty_init(struct jsm_board *brd)
 {
 	int i;
 	void __iomem *vaddr;
@@ -431,7 +431,7 @@ int jsm_tty_init(struct jsm_board *brd)
 	return 0;
 }
 
-int jsm_uart_port_init(struct jsm_board *brd)
+int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
 	struct jsm_channel *ch;
-- 
1.6.0.2

