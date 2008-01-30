Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbYA3UEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbYA3UEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYA3UBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:42 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51717 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYA3UBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:38 -0500
Date: Wed, 30 Jan 2008 22:02:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] parport_ECP_supported() mustn't be __devinit
Message-ID: <20080130200212.GM29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: drivers/parport/built-in.o(.text+0x45ed): Section mismatch in reference from the function parport_pc_probe_port() to the function .devinit.text:parport_ECP_supported()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
10388dc9a0e499125508eaae2c0e60d82859f5e6 
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index e9743d3..69b75ab 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1736,7 +1736,7 @@ static int parport_PS2_supported(struct parport *pb)
 }
 
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb)
+static int parport_ECP_supported(struct parport *pb)
 {
 	int i;
 	int config, configb;
@@ -1960,7 +1960,7 @@ static int parport_ECPEPP_supported(struct parport *pb)
 /* Don't bother probing for modes we know we won't use. */
 static int __devinit parport_PS2_supported(struct parport *pb) { return 0; }
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb) { return 0; }
+static int parport_ECP_supported(struct parport *pb) { return 0; }
 #endif
 static int __devinit parport_EPP_supported(struct parport *pb) { return 0; }
 static int __devinit parport_ECPEPP_supported(struct parport *pb){return 0;}

