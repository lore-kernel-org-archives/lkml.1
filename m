Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZGNPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZGNPyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZGNPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:54:43 -0400
Received: from www.tglx.de ([62.245.132.106]:60263 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbZGNPyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:54:43 -0400
Date: Tue, 14 Jul 2009 17:54:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] core fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907141749380.2777@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus-2

Thanks,

	tglx

------------------>
Sonny Rao (1):
      futexes: Fix infinite loop in get_futex_key() on huge page


 kernel/futex.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 794c862..0672ff8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -247,6 +247,7 @@ again:
 	if (err < 0)
 		return err;
 
+	page = compound_head(page);
 	lock_page(page);
 	if (!page->mapping) {
 		unlock_page(page);
