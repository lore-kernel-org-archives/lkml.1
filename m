Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZB0KZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZB0KZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZB0KZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:25:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZB0KZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:25:30 -0500
Date: Fri, 27 Feb 2009 11:25:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Chris Friesen <cfriesen@nortel.com>, mingo@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] sched: Don't allow setuid to succeed if the user does
	not have rt bandwidth
Message-ID: <20090227102512.GA14530@elte.hu>
References: <20090217050033.GA10409@linux.vnet.ibm.com> <20090217101542.GB15989@linux.vnet.ibm.com> <1234869339.4744.77.camel@laptop> <20090223114541.GD31277@linux.vnet.ibm.com> <1235390396.4645.87.camel@laptop> <20090224091849.GA18693@linux.vnet.ibm.com> <874oyj4yiz.fsf@basil.nowhere.org> <1235493365.4645.2061.camel@laptop> <49A44A86.2030409@nortel.com> <20090227094354.GA6444@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227094354.GA6444@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> 
> Corey Hickey reported that on using setuid to change the uid of a
> rt process, the process would be unkillable and not be running.
> This is because there was no rt runtime for that user group. Add
> in a check to see if a user can attach an rt task to its task group.
> On failure, return EINVAL, which is also returned in
> CONFIG_CGROUP_SCHED.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h |    4 ++++
>  kernel/sched.c        |   13 +++++++++++--
>  kernel/sys.c          |   31 ++++++++++++++++++++-----------
>  kernel/user.c         |   18 ++++++++++++++++++
>  4 files changed, 53 insertions(+), 13 deletions(-)

Applied to tip:sched/urgent, thanks Dhaval!

	Ingo
