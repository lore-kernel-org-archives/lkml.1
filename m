Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZGOQ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZGOQ0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZGOQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:26:05 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:48867 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbZGOQ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:26:03 -0400
Date: Wed, 15 Jul 2009 21:55:56 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] percpu: add dummy pcpu_lpage_remapped() for !CONFIG_SMP
Message-ID: <20090715162556.GA4767@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090706162632.fdde002e.sfr@canb.auug.org.au> <20090706095343.df21d4c9.rdunlap@xenotime.net> <20090709102248.01e2312c.randy.dunlap@oracle.com> <20090715094720.GA6674@linux.vnet.ibm.com> <20090715195807.f0d1a7ea.sfr@canb.auug.org.au> <4A5DA937.6040605@kernel.org> <4A5DEA0D.8050706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A5DEA0D.8050706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo <htejun@gmail.com> [2009-07-15 23:39:09]:

> !CONFIG_SMP was missing pcpu_lpage_remapped() definition causing build
> failure.  Add dummy implementation.  This was discovered by linux-next
> testing.
>

Thanks, the patch fixes the build failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
> Yeap, it was missing dummy definition on !CONFIG_SMP.  This patch
> fixes it.  Committed to percpu#for-next.  Thanks.
> 
>  include/linux/percpu.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 8ce91af..e134c82 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -184,6 +184,11 @@ static inline void free_percpu(void *p)
> 
>  static inline void __init setup_per_cpu_areas(void) { }
> 
> +static inline void *pcpu_lpage_remapped(void *kaddr)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_SMP */
> 
>  #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
> -- 
> 1.6.0.2
			
					Kamalesh
