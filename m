Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXIMJTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXIMJTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbXIMJTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:19:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXIMJTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:19:43 -0400
Date: Thu, 13 Sep 2007 11:19:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913091934.GA26977@elte.hu>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709121405130.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709121405130.1817@scrub.home>
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



* Roman Zippel <zippel@linux-m68k.org> wrote:

> > The sched-devel.git tree can be pulled from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> 
> Am I the only one who can't clone that thing? [...]

Ah - i have messed up my sched-devel.git script so the git-push went to 
kernel.org but into my home directory :-/ Should work now - let me know 
if it doesnt.

i've also uploaded the patch series in quilt format, to:

  http://people.redhat.com/mingo/cfs-scheduler/devel/patches.tar.gz

> [...] It can't be entirely explained with the Kernel Summit, as this 
> is not the first time patches appear out of the blue in form of a git 
> tree.

i'm not sure what you mean, but i can definitely tell you that there was 
no scheduler hacking at the Kernel Summit. (there's no good wireless in 
the pubs and not enough space for a laptop anyway ;)

The impressive linecount has been mostly achieved by dumb removal:

    sched: remove wait_runtime fields and features
    4 files changed, 14 insertions(+), 161 deletions(-)

    sched: remove wait_runtime limit
    5 files changed, 3 insertions(+), 124 deletions(-)

    sched: remove precise CPU load calculations #2
    1 file changed, 1 insertion(+), 31 deletions(-)

    sched: remove precise CPU load
    3 files changed, 9 insertions(+), 41 deletions(-)

    sched: remove stat_gran
    4 files changed, 15 insertions(+), 50 deletions(-)

Hack time to do them: ~10 minutes apiece. Removing stuff is _easy_ :-)

The rest is finegrained, small changes. One of the harder patches was 
this one:

    commit 28c4b8ed35f0fc7050f186147da9e10b55e1e446
    sched: introduce se->vruntime
    3 files changed, 50 insertions(+), 33 deletions(-)

And i sent you the first variant of that already:

    http://lkml.org/lkml/2007/9/2/76

we needed 2 days after the KS to put it into shape and send it out for 
feedback.

	Ingo
