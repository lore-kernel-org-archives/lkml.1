Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYA3UOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYA3UOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYA3UDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:03:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40765 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762889AbYA3UC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:57 -0500
Date: Wed, 30 Jan 2008 22:03:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net, Jeff Garzik <jgarzik@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/net/sunvnet.c:print_version() must be __devinit
Message-ID: <20080130200332.GL29368@does.not.exist>
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
WARNING: drivers/net/sunvnet.o(.text+0x220): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
WARNING: drivers/net/sunvnet.o(.text+0x228): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f865222179806c4475cd79c2fb92ec622f88da3f 
diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index 4a0035f..6415ce1 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1130,7 +1130,7 @@ static struct vio_driver_ops vnet_vio_ops = {
 	.handshake_complete	= vnet_handshake_complete,
 };
 
-static void print_version(void)
+static void __devinit print_version(void)
 {
 	static int version_printed;
 

