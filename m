Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873Ab0AAB24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0AAB24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570Ab0AAB2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:28:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38114 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0AAB2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:28:55 -0500
Date: Thu, 31 Dec 2009 17:28:52 -0800
From: Jun Sun <jsun@junsun.net>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       uclinux-dev@uclinux.org
Subject: [PATCH] error message when FLAT reloc symbol is invalid, v2
Message-ID: <20100101012852.GC16887@Pogoplug>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

See the attachement.

Jun

--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="091231-flat-invalid-reloc-symbol-output.patch"

This patch fixes a cosmetic error in printk. Text segment and data/bss
segment are allocated from two different areas. It is not meaningful to
give the diff between them in the error reporting messages.

Signed-off-by: Jun Sun <jsun@junsun.net>
---

diff -Nru linux-2.6.32.2/fs/binfmt_flat.c.orig linux-2.6.32.2/fs/binfmt_flat.c
--- linux-2.6.32.2/fs/binfmt_flat.c.orig	2009-12-18 14:27:07.000000000 -0800
+++ linux-2.6.32.2/fs/binfmt_flat.c	2009-12-26 08:22:43.000000000 -0800
@@ -355,7 +355,7 @@
 
 	if (!flat_reloc_valid(r, start_brk - start_data + text_len)) {
 		printk("BINFMT_FLAT: reloc outside program 0x%x (0 - 0x%x/0x%x)",
-		       (int) r,(int)(start_brk-start_code),(int)text_len);
+		       (int) r,(int)(start_brk-start_data+text_len),(int)text_len);
 		goto failed;
 	}
 

--jy6Sn24JjFx/iggw--
