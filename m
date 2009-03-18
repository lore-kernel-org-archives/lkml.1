Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZCRM5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZCRM5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbZCRM5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:57:36 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52633 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755721AbZCRM5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:57:35 -0400
Date: Wed, 18 Mar 2009 07:57:35 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, travis@sgi.com,
       steiner@sgi.com
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090318125735.GA8527@sgi.com>
References: <E1LjeSk-0004BW-3x@eag09.americas.sgi.com> <200903180822.31196.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903180822.31196.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Mar 18, 2009 at 08:22:30AM +1030, Rusty Russell wrote:
> On Wednesday 18 March 2009 05:26:30 Cliff Wickman wrote:
> > 
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > A patch on Mar13 2009 introduced a bug. I hope the below 1-line fix can
> > make the 'urgent' list, and get fixed before that patch moves on.
> > 
> > The Mar13 patch is saved at
> > http://marc.info/?l=linux-kernel&m=123683186504948&w=2
> > 
> > The allocation of per-cpu uv_flush_tlb_mask's in arch/x86/kernel/tlb_uv.c
> > changed a variable that should been reset to 0.
> 
> Hi Cliff,
> 
>    Thanks for tracking this.  May I suggest this slightly enhanced version?

Yes, I agree. No need for double initialization.

Thanks.
-Cliff

> 
> Subject: cpumask: fix tlb_uv initialization
> 
> Impact: fix boot on UV systems
> 
> Commit 76ba0ecda0de9accea9a91cb6dbde46782110e1c "cpumask: use cpumask_var_t
> in uv_flush_tlb_others" used cur_cpu as an iterator; it was supposed to be
> zero for the code below it.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
> index 8afb691..deb5ebb 100644
> --- a/arch/x86/kernel/tlb_uv.c
> +++ b/arch/x86/kernel/tlb_uv.c
> @@ -751,7 +751,7 @@ static int __init uv_bau_init(void)
>  	int node;
>  	int nblades;
>  	int last_blade;
> -	int cur_cpu = 0;
> +	int cur_cpu;
>  
>  	if (!is_uv_system())
>  		return 0;
> @@ -765,6 +765,7 @@ static int __init uv_bau_init(void)
>  	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
>  	nblades = 0;
>  	last_blade = -1;
> +	cur_cpu = 0;
>  	for_each_online_node(node) {
>  		blade = uv_node_to_blade_id(node);
>  		if (blade == last_blade)

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
