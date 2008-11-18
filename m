Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbYKRHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbYKRHqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYKRHqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:46:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYKRHqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:46:02 -0500
Date: Tue, 18 Nov 2008 08:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix regression when failed to generate sched
	domains
Message-ID: <20081118074543.GB17838@elte.hu>
References: <49225A5B.6080103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49225A5B.6080103@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> When cpuset failed to generate sched domains due to kmalloc()
> failure, the scheduler should fallback to the single partition
> 'fallback_doms' and rebuild sched domains, but now it only
> destroys but not rebuilds sched domains.
> 
> The regression is introduced by:
> 
> commit dfb512ec4834116124da61d6c1ee10fd0aa32bd6
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Fri Aug 29 13:11:41 2008 -0700
> 
>     sched: arch_reinit_sched_domains() must destroy domains to force rebuild
> 
> After the above commit, partition_sched_domains(0, NULL, NULL) will
> only destroy sched domains and partition_sched_domains(1, NULL, NULL)
> will create the default sched domain.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

applied to tip/sched/urgent, thanks!

> Should I also CC stable for 2.6.27.xx ?

i've added a Cc: stable to the commit - that will trigger a -stable 
backport.

	Ingo
