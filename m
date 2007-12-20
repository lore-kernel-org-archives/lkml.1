Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbXLTJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbXLTJTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXLTJTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:19:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41933 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbXLTJTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:19:34 -0500
Subject: Re: [PATCH] mm: fix exit_mmap BUG() on a.out binary exit
From: Peter Zijlstra <peterz@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071220084707.GB28578@jurassic.park.msu.ru>
References: <20071220084707.GB28578@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 10:19:27 +0100
Message-Id: <1198142367.6484.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 11:47 +0300, Ivan Kokshaysky wrote:
> The problem was introduced by commit "mm: variable length argument
> support" (b6a2fea39318e43fee84fa7b0b90d68bed92d2ba)
> as it didn't update fs/binfmt_aout.c like other binfmt's.
> 
> I noticed that on alpha when accidentally launched old OSF/1
> Acrobat Reader binary. Obviously, other architectures are affected
> as well.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

.24 material I'd say.

> ---
>  fs/binfmt_aout.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index e176d19..7596e1e 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -319,7 +319,6 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
>  	current->mm->free_area_cache = current->mm->mmap_base;
>  	current->mm->cached_hole_size = 0;
>  
> -	current->mm->mmap = NULL;
>  	compute_creds(bprm);
>   	current->flags &= ~PF_FORKNOEXEC;
>  #ifdef __sparc__


