Return-Path: <linux-kernel-owner+w=401wt.eu-S965820AbXCVGHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbXCVGHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXCVGHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:07:07 -0400
Received: from poczta.o2.pl ([193.17.41.142]:59922 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965820AbXCVGGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:06:47 -0400
Date: Thu, 22 Mar 2007 07:11:19 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] lockdep: lockdep_depth vs. debug_locks Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070322061119.GA1466@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru> <20070321181635.GA570@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321181635.GA570@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is some joke:

[PATCH] lockdep: lockdep_depth vs. debug_locks

lockdep really shouldn't be used when debug_locks == 0!


Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc4-git4-/include/linux/lockdep.h 2.6.21-rc4-git4/include/linux/lockdep.h
--- 2.6.21-rc4-git4-/include/linux/lockdep.h	2007-03-20 20:24:17.000000000 +0100
+++ 2.6.21-rc4-git4/include/linux/lockdep.h	2007-03-21 22:32:41.000000000 +0100
@@ -245,7 +245,7 @@ extern void lock_release(struct lockdep_
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
-#define lockdep_depth(tsk)	((tsk)->lockdep_depth)
+#define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
 #else /* !LOCKDEP */
 
