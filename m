Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZEXMWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZEXMWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZEXMWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:22:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZEXMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:22:43 -0400
Message-ID: <4A193BCE.90307@redhat.com>
Date: Sun, 24 May 2009 15:21:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable before
 using it
References: <1242793775.3260.2.camel@localhost.localdomain>
In-Reply-To: <1242793775.3260.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> May be in some cases paging64_fetch() and paging32_fetch() will return sptep
> without initialization.
>
> Also fixes compilation warning:
>   CC      arch/x86/kernel/io_delay.o
>  arch/x86/kvm/paging_tmpl.h: In function ‘paging64_fetch’:
>  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
>  arch/x86/kvm/paging_tmpl.h: In function ‘paging32_fetch’:
>  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 6bd7020..99cb10d 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -276,7 +276,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  {
>  	unsigned access = gw->pt_access;
>  	struct kvm_mmu_page *shadow_page;
> -	u64 spte, *sptep;
> +	u64 spte, *sptep = NULL;
>  	int direct;
>  	gfn_t table_gfn;
>  	int r;
>   

It's a false alarm.  Isn't there a macro to shut up the warning?


-- 
error compiling committee.c: too many arguments to function

