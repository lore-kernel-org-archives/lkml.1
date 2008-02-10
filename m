Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYBJUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYBJUzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYBJUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:55:36 -0500
Received: from opcao.uece.br ([200.129.22.45]:57039 "EHLO opcao.uece.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYBJUzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:55:35 -0500
Message-ID: <47AF64F9.1000203@uece.br>
Date: Sun, 10 Feb 2008 17:56:25 -0300
From: Sergio Luis <sergio@uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org
Subject: [PATCH] drivers/net/sis190: fix section mismatch warning in sis190_get_mac_addr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: drivers/net/sis190.o(.text+0x103): Section mismatch in reference from the function sis190_get_mac_addr() to the function .devinit.text:sis190_get_mac_addr_from_apc()
WARNING: drivers/net/sis190.o(.text+0x10e): Section mismatch in reference from the function sis190_get_mac_addr() to the function .devinit.text:sis190_get_mac_addr_from_eeprom()

Annotate sis190_get_mac_addr() with __devinit.

Signed-off-by: Sergio Luis <sergio@uece.br>

 sis190.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urN linux-2.6.24-git22.orig/drivers/net/sis190.c linux-2.6.24-git22/drivers/net/sis190.c
--- linux-2.6.24-git22.orig/drivers/net/sis190.c	2008-02-10 16:56:37.000000000 -0300
+++ linux-2.6.24-git22/drivers/net/sis190.c	2008-02-10 17:38:36.000000000 -0300
@@ -1630,7 +1630,8 @@
 	SIS_PCI_COMMIT();
 }
 
-static int sis190_get_mac_addr(struct pci_dev *pdev, struct net_device *dev)
+static int __devinit sis190_get_mac_addr(struct pci_dev *pdev, 
+					 struct net_device *dev)
 {
 	u8 from;
 

