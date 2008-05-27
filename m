Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYE0JB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYE0JB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbYE0JBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:01:16 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58255 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbYE0JBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:01:15 -0400
Date: Tue, 27 May 2008 11:58:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527085830.GA20938@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that this is controversial, for further background please see the
discussion in http://bugzilla.kernel.org/show_bug.cgi?id=10761

Facts:
- Bugzilla statistics
  (not counting duplicate bugs and bugs closed as INVALID):
  - 6 CPU scheduler regressions reported during 2.6.25-rc
    1 of them still open as of 2.6.26-rc4
  - 6 CPU scheduler regressions reported during 2.6.26-rc until now
    5 of them still open as of 2.6.26-rc4
  - at about half of the CPU scheduler regressions are related to
    group scheduling
- Peter Zijlstra said in Bugzilla bug #10761:
  > Adrian Bunk said:
  > The CPU scheduler is currently regressing horribly often, and half of the
  > regressions are in group scheduling.
  That is because group scheduling is horribly complex and was never
  feature complete - trying to solve that is high on my list of
  priorities.

My opinion:
- features that alter existing kernel functionality should (different
  from drivers for previously not supported hardware) be in a very good
  state before being offered in stable kernels
- Peter is wrong when he thinks that EXPERIMENTAL would somehow hide
  known-problematic features - in practice nearly everyone has to have 
  EXPERIMENTAL enabled (e.g. for some hardware driver)
- group scheduling already has a history of people accidentally enabling 
  it and then running into problems

I therefore suggest this patch to let GROUP_SCHED depend on BROKEN.

Once it is feature complete and then got the usual testing through
-next I'll have no objections against offering it again to users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c67cfbbb40895b72760865527dd1949631b1d183 diff --git a/init/Kconfig b/init/Kconfig
index d9526b5..564deba 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -333,7 +333,7 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 
 config GROUP_SCHED
 	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
+	depends on BROKEN
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU

