Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXC1GYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXC1GYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933673AbXC1GYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:24:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46520 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675AbXC1GYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:24:07 -0400
Date: Wed, 28 Mar 2007 09:24:03 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH] revoke: generic_file_revoke stub for NOMMU
In-Reply-To: <1175062147.15391.14.camel@roc-desktop>
Message-ID: <Pine.LNX.4.64.0703280923170.30354@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
 <1175062147.15391.14.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As NOMMU does not include fs/revoke.c, we need to provide a stub for
generic_file_revoke() so that filesystems using it compile.

Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: uml-2.6/include/linux/fs.h
===================================================================
--- uml-2.6.orig/include/linux/fs.h	2007-03-28 09:18:57.000000000 +0300
+++ uml-2.6/include/linux/fs.h	2007-03-28 09:20:48.000000000 +0300
@@ -1741,7 +1741,11 @@ extern long do_splice_direct(struct file
 		size_t len, unsigned int flags);
 
 /* fs/revoke.c */
+#ifdef CONFIG_MMU
 extern int generic_file_revoke(struct file *);
+#else
+#define generic_file_revoke NULL
+#endif
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
