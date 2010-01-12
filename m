Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534Ab0ALCN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0ALCN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018Ab0ALCN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:13:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41471 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0ALCN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:13:26 -0500
Date: Tue, 12 Jan 2010 13:13:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20100112131325.f8ebb1c9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
include/linux/kmemcheck.h between commit
e992cd9b72a18122bd5c958715623057f110793f ("kmemcheck: make bitfield
annotations truly no-ops when disabled") from Linus' tree and commit
a5fddb6f013523418c30cd795b0f8ecf49505952
("misc:remove-MAYBE_BUILD_BUG_ON") from the rr tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 08d7dc4..39f8453 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -76,7 +76,7 @@ bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
 									\
 		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		MAYBE_BUILD_BUG_ON(_n < 0);				\
+		BUILD_BUG_ON(_n < 0);					\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
