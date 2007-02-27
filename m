Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXB0TTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXB0TTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXB0TTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:19:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50766
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbXB0TTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:19:01 -0500
Date: Tue, 27 Feb 2007 11:19:00 -0800 (PST)
Message-Id: <20070227.111900.68039270.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]: Bug in MM_RB debugging?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The code is seemingly trying to make sure that rb_next()
brings us to successive increasing vma entries.

But the two variables, prev and pend, used to perform these
checks, are never advanced.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/mm/mmap.c b/mm/mmap.c
index eb509ae..84f997d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -299,6 +299,8 @@ static int browse_rb(struct rb_root *root)
 			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start);
 		i++;
 		pn = nd;
+		prev = vma->vm_start;
+		pend = vma->vm_end;
 	}
 	j = 0;
 	for (nd = pn; nd; nd = rb_prev(nd)) {
