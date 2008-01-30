Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbYA3ULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbYA3ULs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761210AbYA3UCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51802 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbYA3UCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:43 -0500
Date: Wed, 30 Jan 2008 22:03:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] hvc_rtas_init() must be __init
Message-ID: <20080130200317.GH29368@does.not.exist>
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
WARNING: vmlinux.o(.text+0x2fbca8): Section mismatch in reference from the function .hvc_rtas_init() to the function .devinit.text:.hvc_alloc()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1cc00c4ad5c881db2fc256ced43f3b5ce5c76e1c 
diff --git a/drivers/char/hvc_rtas.c b/drivers/char/hvc_rtas.c
index bb09413..88590d0 100644
--- a/drivers/char/hvc_rtas.c
+++ b/drivers/char/hvc_rtas.c
@@ -76,7 +76,7 @@ static struct hv_ops hvc_rtas_get_put_ops = {
 	.put_chars = hvc_rtas_write_console,
 };
 
-static int hvc_rtas_init(void)
+static int __init hvc_rtas_init(void)
 {
 	struct hvc_struct *hp;
 

