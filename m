Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbZHVS4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbZHVS4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbZHVS4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:56:43 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50121 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbZHVS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:56:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: airlied@redhat.com
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/1] GPU: vgaarb, use %p in pointers prints
Date: Sat, 22 Aug 2009 20:56:43 +0200
Message-Id: <1250967403-30249-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid compiler warnings about different size, remove
pointer-to-int cast and use %p directly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/vga/vgaarb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 199138f..2f69cd0 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -831,7 +831,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 5;
 		remaining -= 5;
 
-		pr_devel("client 0x%X called 'lock'\n", (int)priv);
+		pr_devel("client %p called 'lock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -867,7 +867,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 7;
 		remaining -= 7;
 
-		pr_devel("client 0x%X called 'unlock'\n", (int)priv);
+		pr_devel("client %p called 'unlock'\n", priv);
 
 		if (strncmp(curr_pos, "all", 3) == 0)
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
@@ -917,7 +917,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 8;
 		remaining -= 8;
 
-		pr_devel("client 0x%X called 'trylock'\n", (int)priv);
+		pr_devel("client %p called 'trylock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -960,7 +960,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		curr_pos += 7;
 		remaining -= 7;
-		pr_devel("client 0x%X called 'target'\n", (int)priv);
+		pr_devel("client %p called 'target'\n", priv);
 		/* if target is default */
 		if (!strncmp(buf, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
@@ -1014,7 +1014,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	} else if (strncmp(curr_pos, "decodes ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
-		pr_devel("vgaarb: client 0x%X called 'decodes'\n", (int)priv);
+		pr_devel("vgaarb: client %p called 'decodes'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
-- 
1.6.3.3

