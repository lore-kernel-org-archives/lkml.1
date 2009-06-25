Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZFYSPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZFYSPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFYSPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:15:42 -0400
Received: from www.tglx.de ([62.245.132.106]:60227 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZFYSPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:15:41 -0400
Date: Thu, 25 Jun 2009 20:15:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: [GIT pull] final futex fixes for 2.6.31
In-Reply-To: <20090625100413.GD29980@elte.hu>
Message-ID: <alpine.LFD.2.00.0906251940570.2767@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain> <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain> <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain> <1245897826.2560.421.camel@ymzhang> <alpine.LFD.2.00.0906251151400.2767@localhost.localdomain>
 <20090625100413.GD29980@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I'm truly embarrassed to ask you to pull the latest futexes-for-linus
git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

I did not just copy your suggestion blindly, I even wondered and
looked up the prototype in mm.h which has the 4th argument "int len"
and said to myself "hey, Linus is right as usual" while in reality
"len" is number of pages.

As I'm running out of brown paperbags I'm declaring all futex bugs
fixed by definition. Futex bugs which will be discovered from now on
are going to be automatically converted to documented features.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      futex: request only one page from get_user_pages()


 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1c33711..794c862 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -299,7 +299,7 @@ void put_futex_key(int fshared, union futex_key *key)
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
 	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
-				 sizeof(*uaddr), 1, 0, NULL, NULL);
+				 1, 1, 0, NULL, NULL);
 	return ret < 0 ? ret : 0;
 }
 
