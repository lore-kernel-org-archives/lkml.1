Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbYA3UDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbYA3UDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYA3UBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:41 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40665 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbYA3UBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:34 -0500
Date: Wed, 30 Jan 2008 22:02:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ibmlana_init_one() must be __devinit
Message-ID: <20080130200208.GK29368@does.not.exist>
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
WARNING: drivers/net/built-in.o(.text+0x1148a5): Section mismatch in reference from the function ibmlana_init_one() to the variable .init.data:ibmlana_adapter_names
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ec20d90864ce5b935b10bb9190be09686aa94904 
diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
index 46e2c52..4ccc1cd 100644
--- a/drivers/net/ibmlana.c
+++ b/drivers/net/ibmlana.c
@@ -906,7 +906,7 @@ static char *ibmlana_adapter_names[] __initdata = {
 	NULL
 };
 
-static int ibmlana_init_one(struct device *kdev)
+static int __devinit ibmlana_init_one(struct device *kdev)
 {
 	struct mca_device *mdev = to_mca_device(kdev);
 	struct net_device *dev;


