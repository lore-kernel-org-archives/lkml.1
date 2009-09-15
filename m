Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478AbZIOH7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbZIOH7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZIOH7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:59:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZIOH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:59:36 -0400
Date: Tue, 15 Sep 2009 09:59:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fix
Message-ID: <20090915075931.GA24171@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

 Thanks,

	Ingo

------------------>
Xiao Guangrong (1):
      perf_counter: Fix buffer overflow in perf_copy_attr()


 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7cbc57..a67a1dc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4171,6 +4171,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			if (val)
 				goto err_size;
 		}
+		size = sizeof(*attr);
 	}
 
 	ret = copy_from_user(attr, uattr, size);
