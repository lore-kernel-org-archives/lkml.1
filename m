Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbXGJMpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbXGJMpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXGJMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56639 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752927AbXGJMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:04 -0400
Date: Tue, 10 Jul 2007 14:44:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] tokenring/3c359.c:xl_init() must be __devinit
Message-ID: <20070710124437.GS3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: drivers/built-in.o(.text+0x361ef1): Section mismatch: reference to .init.text:xl_init (between 'xl_probe' and 'xl_hw_reset')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/net/tokenring/3c359.c.old	2007-07-10 04:07:19.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/tokenring/3c359.c	2007-07-10 04:08:01.000000000 +0200
@@ -363,7 +363,7 @@
 }
 
 
-static int __init xl_init(struct net_device *dev) 
+static int __devinit xl_init(struct net_device *dev) 
 {
     	struct xl_private *xl_priv = (struct xl_private *)dev->priv ;
 

