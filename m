Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZJMKhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZJMKhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbZJMKhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:37:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZJMKhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:37:45 -0400
Date: Tue, 13 Oct 2009 12:37:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jia Zhang <jia.zhang2008@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: keep current softlockup period before
	touching timestamp
Message-ID: <20091013103703.GC3915@elte.hu>
References: <4ABEFCFE.3080500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABEFCFE.3080500@gmail.com>
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


* Jia Zhang <jia.zhang2008@gmail.com> wrote:

> From: Jia Zhang <jia.zhang2008@gmail.com>
> 
> Imaging such a scenario, softlockup deadline is 60s and a softirq runs 
> at most 65s. Assume that currently that softirq runs 50s. At this 
> moment, issue a "echo 40 > /proc/sys/kernel/softlockup_thresh" and 
> thus lead to recounting the timeout. The remaining time for that 
> softirq is 15s less than new threshold 40s, which means the warning 
> will be depressed after 15s. It is not what we expected because 
> softlockup actually feeds 100s(old+new) for that softirq. To fix this 
> problem, softlockup should keep current softlockup period before 
> touching timestamp.
> 
> Signed-off-by: Jia Zhang <jia.zhang2008@gmail.com>
> ---
>  include/linux/sched.h |    5 +----
>  kernel/softlockup.c   |   26 ++++++++++++++------------
>  kernel/sysctl.c       |    2 +-
>  3 files changed, 16 insertions(+), 17 deletions(-)

your patch does not apply to the latest kernel - mind redoing it against 
latest -tip:

  http://people.redhat.com/mingo/tip.git/README

also please re-post the other patch of yours as well, the "allow 
checking for remote CPUs" - that too looks like a worthwile improvement.

Thanks,

	Ingo
