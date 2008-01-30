Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbYA3UMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbYA3UMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbYA3UC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:56 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51819 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbYA3UCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:52 -0500
Date: Wed, 30 Jan 2008 22:03:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] block/sunvdc.c:print_version() must be __devinit
Message-ID: <20080130200327.GK29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: drivers/block/sunvdc.o(.text+0xf0): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
WARNING: drivers/block/sunvdc.o(.text+0xf8): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
302ffded3690214f130c66a7343ad23a1fb7dbbc 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 66e3015..a8de037 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -732,7 +732,7 @@ static struct vio_driver_ops vdc_vio_ops = {
 	.handshake_complete	= vdc_handshake_complete,
 };
 
-static void print_version(void)
+static void __devinit print_version(void)
 {
 	static int version_printed;
 

