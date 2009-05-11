Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZEKNM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZEKNM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZEKNMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:12:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZEKNMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:12:48 -0400
Date: Mon, 11 May 2009 15:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, Ian.Campbell@eu.citrix.com,
       xen-devel@lists.xensource.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
Message-ID: <20090511131230.GA32693@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com> <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org>
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


* tip-bot for Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> Commit-ID:  636afdbe85d50d9b88f5283b5e6d0f8518431aac
> Gitweb:     http://git.kernel.org/tip/636afdbe85d50d9b88f5283b5e6d0f8518431aac
> Author:     Ian Campbell <Ian.Campbell@eu.citrix.com>
> AuthorDate: Fri, 8 May 2009 16:52:07 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 11 May 2009 15:08:08 +0200
> 
> x86: use flush_tlb_others to implement flush_tlb_all, fix
> 
> "use the flush_tlb_others() call to implement flush_tlb_all()"
> causes:
>          BUG: spinlock bad magic on CPU#0, swapper/0
>           lock: c05b7588, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>          Pid: 0, comm: swapper Not tainted 2.6.30-rc3-x86_32p-xen0-tip-01797-g3db7847 #1054
>          Call Trace:
>           [<c023e656>] spin_bug+0x96/0xf0
>           [<c023e90f>] _raw_spin_lock+0x6f/0x150
> 
> It can be called before the core_initcalls are run. Explicitly call
> init_smp_flush early on.
> 
> Also there is no need for init_smp_flush to be __cpuinit.
> 
> [ Impact: fix boot crash/warning ]
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Xen-devel <xen-devel@lists.xensource.com>
> Acked-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
> LKML-Reference: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/include/asm/tlbflush.h |    2 ++
>  arch/x86/mm/tlb.c               |    3 +--
>  init/main.c                     |    1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)

which then does:

init/main.c:728: error: implicit declaration of function ‘init_smp_flush’

i've excluded tip:x86/xen from tip:master for now.

	Ingo
