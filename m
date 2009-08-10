Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZHJV5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZHJV5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZHJV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:57:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZHJV5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:57:08 -0400
Message-ID: <4A80979E.3080204@zytor.com>
Date: Mon, 10 Aug 2009 14:56:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] export cpu_tlbstate to modules
References: <cover.1249930169.git.mst@redhat.com> <20090810185302.GB13924@redhat.com>
In-Reply-To: <20090810185302.GB13924@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2009 11:53 AM, Michael S. Tsirkin wrote:
> vhost net module wants to do copy to/from user from a kernel thread,
> which needs switch_mm (like what fs/aio has).
> export cpu_tlbstate to make this possible
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/mm/tlb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 821e970..e33a5f0 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -13,6 +13,7 @@
>  
>  DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
>  			= { &init_mm, 0, };
> +EXPORT_PER_CPU_SYMBOL_GPL(cpu_tlbstate);
>  
>  /*
>   *	Smarter SMP flushing macros.

Wouldn't it be a *lot* better to move use_mm() from fs/aio.c into common
code, and export that instead?

	-hpa

