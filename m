Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZEaKur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZEaKur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZEaKui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:50:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57442 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZEaKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:50:37 -0400
Date: Sun, 31 May 2009 13:50:38 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: alan@lxorguk.ukuu.org.uk, cl@linux-foundation.org, mpm@selenic.com,
       npiggin@suse.de
Subject: [PATCH] slab: document kzfree() zeroing behavior
Message-ID: <Pine.LNX.4.64.0905311349160.17837@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Alan Cox, document the fact that kzfree() can zero out a great
deal more memory than the what the user requested from kmalloc().

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/util.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 55bef16..e79572b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -166,6 +166,10 @@ EXPORT_SYMBOL(krealloc);
  *
  * The memory of the object @p points to is zeroed before freed.
  * If @p is %NULL, kzfree() does nothing.
+ *
+ * Note: this function zeroes the whole allocated buffer which can be a good
+ * deal bigger than the requested buffer size passed to kmalloc(). So be
+ * careful when using this function in performance sensitive code.
  */
 void kzfree(const void *p)
 {
-- 
1.6.0.6

