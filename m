Return-Path: <linux-kernel-owner+w=401wt.eu-S1765472AbYDYSCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765472AbYDYSCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764803AbYDYR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:24 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53123 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762588AbYDYR5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:03 -0400
Date: Fri, 25 Apr 2008 13:56:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 17/19] UML - use DIV_ROUND_UP
Message-ID: <20080425175617.GA11204@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <olsajiri@gmail.com>

I just saw similar patches in the janitor kernel's list,
and spotted place it fits.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-git/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/ubd_kern.c	2008-04-24 16:51:07.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/ubd_kern.c	2008-04-24 17:06:17.000000000 -0400
@@ -1004,8 +1004,8 @@ static void cowify_bitmap(__u64 io_offse
 	 * by one word.  Thanks to Lynn Kerby for the fix and James McMechan
 	 * for the original diagnosis.
 	 */
-	if(*cow_offset == ((bitmap_len + sizeof(unsigned long) - 1) /
-			   sizeof(unsigned long) - 1))
+	if (*cow_offset == (DIV_ROUND_UP(bitmap_len,
+					 sizeof(unsigned long)) - 1))
 		(*cow_offset)--;
 
 	bitmap_words[0] = bitmap[*cow_offset];
