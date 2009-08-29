Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZH2LCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZH2LCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 07:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZH2LCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 07:02:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbZH2LCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 07:02:11 -0400
Date: Sat, 29 Aug 2009 13:00:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <ericxiao.gr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
Message-ID: <20090829110046.GA6812@elte.hu>
References: <4A90AADE.20307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A90AADE.20307@gmail.com>
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


* Xiao Guangrong <ericxiao.gr@gmail.com> wrote:

> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Some fixed_addresses items are only used when system boot, after 
> boot, they are free but no way to use, like early ioremap area. 
> They are wasted for us, we can reuse them after system boot.
> 
> In this patch, we put them in permanent kmap's area and expand 
> vmalloc's address range. In boot time, reserve them in 
> permanent_kmaps_init() to avoid multiple used, after system boot, 
> we unreserved them then user can use it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/fixmap.h           |    2 ++
>  arch/x86/include/asm/pgtable_32_types.h |    4 ++--
>  arch/x86/mm/init_32.c                   |    8 ++++++++
>  include/linux/highmem.h                 |    2 ++
>  mm/highmem.c                            |   26 ++++++++++++++++++++++++++
>  5 files changed, 40 insertions(+), 2 deletions(-)

I'm wondering, how much space do we save this way, on a typical 
bootup on a typical PC?

	Ingo
