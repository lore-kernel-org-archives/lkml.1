Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZCFIG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZCFIG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZCFIGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:06:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55298 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCFIGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:06:50 -0500
Date: Fri, 6 Mar 2009 09:06:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Subject: Re: [GIT PULL] x86, percpu: implement and use reserved percpu alloc
Message-ID: <20090306080635.GA30269@elte.hu>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Please pull from the following git vector.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> This patchset implements reserved percpu alloc from the first 
> chunk and uses it for static perpcu variables in modules on 
> x86_64.  This is necessary because x86_64 expects symbols to 
> be relocatable using 32bit relocations but dynamic percpu 
> allocation does not guarantee it leading to relocation 
> overflow during module load.
> 
> This can happen to any of the x86_64 percpu first chunk 
> allocators but the embedding allocator is most likely to 
> trigger it as the first chunk is located in the normal kernel 
> memory allocation area while all the other chunks will be 
> allocated in the vmalloc area which is very far from the first 
> chunk.
> 
> This type of reservation will be necessary for other 
> architectures too where addressing mode used for percpu acess 
> uses offsets with limited range to access symbols (e.g. ia64 
> w/ the magic 64k percpu page).
> 
> This problem was first reported and bisected by Mike 
> Galbraith[2].
> 
> This patchset is against the current x86/core/percpu[1] and contains
> the following patches.
> 
>  0001-percpu-clean-up-percpu-constants.patch
>  0002-percpu-cosmetic-renames-in-pcpu_setup_first_chunk.patch
>  0003-percpu-improve-first-chunk-initial-area-map-handlin.patch
>  0004-percpu-use-negative-for-auto-for-pcpu_setup_first_c.patch
>  0005-x86-make-embedding-percpu-allocator-return-excessiv.patch
>  0006-percpu-add-an-indirection-ptr-for-chunk-page-map-ac.patch
>  0007-percpu-module-implement-reserved-allocation-and-us.patch
>  0008-x86-percpu-setup-reserved-percpu-area-for-x86_64.patch
> 
> 0001-0004 makes misc updates to percpu in preparation of later 
> changes.  0005 fixes a case where excessive memory can be set 
> aside in the first chunk when using the embedding allocator.  
> 0006-0008 implement reserved allocation and use it for x86_64.
> 
> Bryan Wu, can you please review #0001?  It contains small 
> change in blackfin.  It's mostly trivial but just in case.
> 
> Diffstat follows.
> 
>  arch/blackfin/include/asm/percpu.h |   10 -
>  arch/x86/kernel/setup_percpu.c     |   73 +++++++---
>  include/linux/percpu.h             |   60 +++-----
>  kernel/module.c                    |    2 
>  mm/percpu.c                        |  267 ++++++++++++++++++++++++++-----------
>  5 files changed, 274 insertions(+), 138 deletions(-)

Pulled, thanks Tejun!

	Ingo
