Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbYBMVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbYBMVsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbYBMVbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:19 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50859 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764238AbYBMVbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:13 -0500
Date: Wed, 13 Feb 2008 23:30:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] hvc_rtas_init() must be __init
Message-ID: <20080213213057.GQ3383@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 30 Jan 2008

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
 

