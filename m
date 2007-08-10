Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXHJVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXHJVXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXHJVWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:22:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXHJVWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:22:50 -0400
Date: Fri, 10 Aug 2007 23:22:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070810212243.GA10251@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

this includes a regression fix and two minor fixes. The regression was 
noticed today by Arjan on the F8-Test1 kernel (which uses .23-rc2): if 
his laptop boots from battery then cpu_khz gets mis-detected and 
subsequently sched_clock() runs too fast - causing interactivity 
problems. This was a pre-existing sched_clock() regression and those 
sched_clock() problems are being addressed by Andi's cpufreq sched-clock 
patchset, but meanwhile i've fixed the regression by making the 
rq->clock logic more robust against such type of sched_clock() 
anomalies. (it was already robust against time warps) Arjan tested the 
fix and it solved the problem. There's also a small 
kernel-address-information-leak fix for the SCHED_DEBUG case noticed by 
Arjan and a fix for a SCHED_GROUP_FAIR branch (not enabled upstream, but 
still working if enabled manually).

	Ingo

---------------->
Ingo Molnar (3):
      sched: improve rq-clock overflow logic
      sched: fix typo in the FAIR_GROUP_SCHED branch
      sched debug: dont print kernel address in /proc/sched_debug

 sched.c       |   15 +++++++++++++--
 sched_debug.c |    2 +-
 sched_fair.c  |    7 +++----
 3 files changed, 17 insertions(+), 7 deletions(-)
