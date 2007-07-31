Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbXGaWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbXGaWST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbXGaWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:18:05 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1814 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbXGaWSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:18:01 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 80] fs/ext4/xattr.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:18:02 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010018.02479.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/ext4/xattr.c | 42421 -> 42382 (-39 bytes)
 fs/ext4/xattr.o | 166152 -> 165720 (-432 bytes)

 fs/ext4/xattr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/ext4/xattr.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/ext4/xattr.c	2007-07-29 23:55:37.000000000 +0200
@@ -750,12 +750,11 @@ ext4_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
 			goto cleanup;
-		memset(s->base, 0, sb->s_blocksize);
 		header(s->base)->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);
