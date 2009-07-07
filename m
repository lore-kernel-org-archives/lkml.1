Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZGGPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZGGPdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZGGPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:32:57 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:38016 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZGGPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:32:56 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com>
References: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 17:32:51 +0200
Message-Id: <1246980771.9777.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
> (Applies to current Linus tree, as of 2.6.31-rc2)
> 
> A third limit becomes apparent as being too low after raising
> MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
> elusive to trigger.

Hrmm, I really wonder what takes all these chains, I never run into this
stuff. We recently fixed the dma-debug code to generate less classes,
could there be more such bugs?

> Signed-off-by: Joao Correia <joaomiguelcorreia@gmail.com>
> 
> ---
>  kernel/lockdep_internals.h | 2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index 699a2ac..93af1f1 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -56,7 +56,7 @@ enum {
>   */
>  #define MAX_LOCKDEP_ENTRIES    16384UL
> 
> -#define MAX_LOCKDEP_CHAINS_BITS        15
> +#define MAX_LOCKDEP_CHAINS_BITS        16
>  #define MAX_LOCKDEP_CHAINS     (1UL << MAX_LOCKDEP_CHAINS_BITS)
> 
>  #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
> ---

