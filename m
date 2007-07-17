Return-Path: <linux-kernel-owner+w=401wt.eu-S1764938AbXGQQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764938AbXGQQgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXGQQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:36:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41468 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXGQQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:36:11 -0400
Date: Tue, 17 Jul 2007 12:35:08 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com, andrea@suse.de
Subject: Re: [PATCH 06/17] lib: percpu_counter_init_irq
Message-ID: <20070717163508.GB15421@filer.fsl.cs.sunysb.edu>
References: <20070614215817.389524447@chello.nl> <20070614220446.724626895@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614220446.724626895@chello.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:58:23PM +0200, Peter Zijlstra wrote:
> provide a way to init percpu_counters that are supposed to be used from irq
> safe contexts.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/percpu_counter.h |    4 ++++
>  lib/percpu_counter.c           |    8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> Index: linux-2.6/include/linux/percpu_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu_counter.h
> +++ linux-2.6/include/linux/percpu_counter.h
> @@ -31,6 +31,8 @@ struct percpu_counter {
>  #endif
>  
>  void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
> +void percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
> +
>  void percpu_counter_destroy(struct percpu_counter *fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_mod(struct percpu_counter *fbc, s32 amount, s32 batch);
> @@ -89,6 +91,8 @@ static inline void percpu_counter_init(s
>  	fbc->count = amount;
>  }
>  
> +#define percpu_counter_init_irq percpu_counter_init

Huh? I'm confused. You have prototypes for both, and now a #define?

Josef 'Jeff' Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
