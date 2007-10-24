Return-Path: <linux-kernel-owner+w=401wt.eu-S1764575AbXJXQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764575AbXJXQra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbXJXQ0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:15 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32771 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760107AbXJXQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:09 -0400
Date: Wed, 24 Oct 2007 18:26:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa iss_net_setup() must be __init
Message-ID: <20071024162637.GN30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x395c): Section mismatch: reference to .init.text:__alloc_bootmem (between '__invalidate_dcache_all' and '__simc')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4cefa581c6b3aa4a474516f8916fdad2a8fb233f 
diff --git a/arch/xtensa/platform-iss/network.c b/arch/xtensa/platform-iss/network.c
index b61fb36..506ac13 100644
--- a/arch/xtensa/platform-iss/network.c
+++ b/arch/xtensa/platform-iss/network.c
@@ -746,7 +746,7 @@ struct iss_net_init {
 
 #define ERR KERN_ERR "iss_net_setup: "
 
-static int iss_net_setup(char *str)
+static int __init iss_net_setup(char *str)
 {
 	struct iss_net_private *device = NULL;
 	struct iss_net_init *new;

