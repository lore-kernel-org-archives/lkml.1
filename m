Return-Path: <linux-kernel-owner+w=401wt.eu-S1030660AbXCSVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030660AbXCSVnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXCSVnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXCSVmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:43 -0400
Date: Mon, 19 Mar 2007 14:40:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ankita Garg <ankita@in.ibm.com>,
       Nick Piggin <npiggin@suse.de>, William Irwin <wli@holomorphy.com>
Subject: [patch 27/31] oom fix: prevent oom from killing a process with children/sibling unkillable
Message-ID: <20070319214054.GC9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ankita Garg <ankita@in.ibm.com>

[PATCH] oom fix: prevent oom from killing a process with children/sibling unkillable

Looking at oom_kill.c, found that the intention to not kill the selected
process if any of its children/siblings has OOM_DISABLE set, is not being
met.

Signed-off-by: Ankita Garg <ankita@in.ibm.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -320,7 +320,7 @@ static int oom_kill_task(struct task_str
 	 * Don't kill the process if any threads are set to OOM_DISABLE
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && p->oomkilladj == OOM_DISABLE)
+		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
 			return 1;
 	} while_each_thread(g, q);
 

-- 
