Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYCMWce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYCMWce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbYCMWaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:30:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbYCMWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=g+Gp5G6eaEJf5wasZvkoFhNE9l8xPL4dR6u2Wu6hS0k80T4D7g19Dd8uyc51eAx5rsNh6j9TTHxfPZNOOde+hXdpoPJkTQXYt90llm+ZDpLW7txKIbnhBpmu0XOFuUTHykbYB4/q7xm+qP8fI9fGYw6fPBkx0Ui4KwermZMs0KQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:46 +0100
Message-Id: <20080313224446.7051.13895.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/12] opti621: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/opti621.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -123,6 +123,8 @@
 
 static int reg_base;
 
+static int pci_clock;
+
 #define PIO_NOT_EXIST 254
 #define PIO_DONT_KNOW 255
 
@@ -210,7 +212,7 @@ static void compute_clocks(int pio, pio_
 {
 	if (pio != PIO_NOT_EXIST) {
 		int adr_setup, data_pls;
-		int bus_speed = system_bus_clock();
+		int bus_speed = pci_clock ? pci_clock : system_bus_clock();
 
 		adr_setup = ide_pio_timings[pio].setup_time;
 		data_pls = ide_pio_timings[pio].active_time;
@@ -376,6 +378,9 @@ static int __init opti621_ide_init(void)
 
 module_init(opti621_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Opti621 IDE");
 MODULE_LICENSE("GPL");
