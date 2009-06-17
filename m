Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbZFQBA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbZFQBA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759092AbZFQBAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:00:16 -0400
Received: from anduin.net ([213.225.74.230]:50302 "EHLO anduin.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbZFQBAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:00:15 -0400
X-Greylist: delayed 2067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 21:00:15 EDT
Date: Wed, 17 Jun 2009 02:25:48 +0200 (CEST)
From: =?UTF-8?Q?Erik_Inge_Bols=C3=B8?= <knan-lkml@anduin.net>
X-X-Sender: knan@anduin.net
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: s626: only claim some subsystem ids
Message-ID: <alpine.BSF.1.00.0906170212180.19435@anduin.net>
User-Agent: Alpine 1.00 (BSF 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix comedi s626 driver mistakenly binding to SAA7146 dvb cards, match only
the same subsystem ids the vendor reference driver s626 v1.0.1 does.

Signed-off-by: Erik Inge Bolsø <knan-lkml@anduin.net>
---
 drivers/staging/comedi/drivers/s626.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Looks obvious enough, but totally untested patch. Vendor driver consulted 
found from http://www.sensoray.com/products/626data.htm ... this driver 
looks to have been forked from it years ago, according to the source 
comments.

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..5f1d373 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -111,7 +111,9 @@ static const struct s626_board s626_boards[] = {
 #define PCI_DEVICE_ID_S626 0x7146
 
 static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
-	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0626, 0, 0,
+		0},
+	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0,
 		0},
 	{0}
 };
-- 
1.5.6.3
