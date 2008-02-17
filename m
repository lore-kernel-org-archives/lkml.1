Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYBQM3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYBQM3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYBQMXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:17 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38368 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbYBQMW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:59 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-serial@vger.kernel.org
Subject: [PATCH 01/27] serial: silence section mismatch warnings in 8250_pci
Date: Sun, 17 Feb 2008 13:22:38 +0100
Message-Id: <1203250984-11285-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: drivers/serial/built-in.o(.data+0x5b8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_ite887x_exit()
WARNING: drivers/serial/built-in.o(.data+0x5e0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x608): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x658): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x680): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x6a8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x6d0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x6f8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x720): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x748): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()

pci_serial_quirks contains a number of function pointers
where the referenced function is annotated __devexit.
This is OK so we annotate pci_serial_quirks with
__refdata to ignore the __devexit references

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-serial@vger.kernel.org
---
 drivers/serial/8250_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index a8bec49..c4b77a5 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -775,7 +775,7 @@ pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
  * This list is ordered alphabetically by vendor then device.
  * Specific entries must come before more generic entries.
  */
-static struct pci_serial_quirk pci_serial_quirks[] = {
+static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	/*
 	* ADDI-DATA GmbH communication cards <info@addi-data.com>
 	*/
-- 
1.5.4.rc3.14.g44397

