Return-Path: <linux-kernel-owner+w=401wt.eu-S1765405AbYAaPBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765405AbYAaPBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYAaPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:01:43 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:4109 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbYAaPBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=WQah7eUx48FvPRy1dzN7MrainMZcSm37lmlE+XxKHLvJ44MpygvzqwR3aJQCcuD54ntIOj+k2nGT3LxgV5VaDZOgHuG0BvOOveWhJEdfjov0rkPWQSBvm6LfG4YwV6MOl/dmkR8tJkZmcc5FIT7GxZGiZicnvLbFZ/Q2GVKkMqo=
Date: Thu, 31 Jan 2008 22:59:00 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>
Subject: [Patch] include/asm-generic/tlb.h: fix a missing header
Message-ID: <20080131145900.GB2471@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes this build error in current -git tree:

  CC      kernel/sched.o
In file included from include/asm/arch/tlb.h:10,
                 from include/asm/tlb.h:5,
                 from kernel/sched.c:71:
include/asm-generic/tlb.h: In function 'tlb_finish_mmu':
include/asm-generic/tlb.h:91: error: implicit declaration of function 'check_pgt_cache'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2


Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 6ce9f3a..4ebbe15 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/quicklist.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 /*
  * For UP we don't need to worry about TLB flush
