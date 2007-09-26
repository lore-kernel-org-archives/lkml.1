Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXIZFQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXIZFQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbXIZFQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:16:27 -0400
Received: from ozlabs.org ([203.10.76.45]:57299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbXIZFQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:16:27 -0400
Subject: [PATCH] lguest example launcher truncates block device file to 0
	length on problems
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lguest <lguest@ozlabs.org>, Chris Malley <mail@chrismalley.co.uk>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 14:19:18 +1000
Message-Id: <1190780358.2227.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Malley <mail@chrismalley.co.uk>

The function should also use ftruncate64() rather than ftruncate() to prevent
files over 4GB (not uncommon for a root filesystem) being zeroed.

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r bcbb99849fd9 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Wed Sep 26 12:21:40 2007 +1000
+++ b/Documentation/lguest/lguest.c	Wed Sep 26 14:15:38 2007 +1000
@@ -882,7 +882,7 @@ static u32 handle_block_output(int fd, c
 		 * of the block file (possibly extending it). */
 		if (off + len > device_len) {
 			/* Trim it back to the correct length */
-			ftruncate(dev->fd, device_len);
+			ftruncate64(dev->fd, device_len);
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, len);
 		}


