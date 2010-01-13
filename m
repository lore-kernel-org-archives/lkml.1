Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525Ab0AMOBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0AMOBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431Ab0AMOAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:00:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:28557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab0AMOAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:00:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,268,1262592000"; 
   d="scan'208";a="586774987"
Message-Id: <20100113135957.545276953@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jan 2010 21:53:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kelly Bowa <kmb@tuxedu.org>, Andi Kleen <andi@firstfloor.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, <stable@kernel.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 3/8] devmem: fix kmem write bug on memory holes
References: <20100113135305.013124116@intel.com>
Content-Disposition: inline; filename=vwrite-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_kmem() used to assume vwrite() always return the full buffer length.
However now vwrite() could return 0 to indicate memory hole. This creates
a bug that "buf" is not advanced accordingly.

Fix it to simply ignore the return value, hence the memory hole.

CC: Kelly Bowa <kmb@tuxedu.org>
CC: Andi Kleen <andi@firstfloor.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <stable@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-11 10:32:32.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-11 10:32:34.000000000 +0800
@@ -555,7 +555,7 @@ static ssize_t write_kmem(struct file * 
 				err = -EFAULT;
 				break;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
+			vwrite(kbuf, (char *)p, sz);
 			count -= sz;
 			buf += sz;
 			virtr += sz;


