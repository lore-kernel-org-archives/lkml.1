Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbXHALiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbXHALiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbXHALiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:38:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520AbXHALiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:38:05 -0400
Date: Wed, 1 Aug 2007 13:37:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801113759.GA12523@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> [...] the increase in code size:
> 
> 2.6.22:
>    text    data     bss     dec     hex filename
>   10150      24    3344   13518    34ce kernel/sched.o
> 
> recent git:
>    text    data     bss     dec     hex filename
>   14724     228    2020   16972    424c kernel/sched.o
> 
> That's i386 without stats/debug. [...]

that's without CONFIG_SMP, right? :-) On SMP they are about net break 
even:

     text    data     bss     dec     hex filename
    26535    4173      24   30732    780c kernel/sched.o-2.6.22
    28378    2574      16   30968    78f8 kernel/sched.o-2.6.23-git

(plus a further ~1.5K per CPU data reduction which is not visible here) 

btw., here's the general change in size of a generic vmlinux from .22 to 
.23-git, using the same .config:

     text    data     bss     dec     hex filename
  5256628  520760 1331200 7108588  6c77ec vmlinux.22
  5306918  535844 1327104 7169866  6d674a vmlinux.23-git

+50K. (this was on UP)

In any case, there's still some debugging code in the scheduler (beyond 
SCHED_DEBUG), i'll work some more on reducing it.

	Ingo
