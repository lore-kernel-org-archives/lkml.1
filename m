Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbYGJRcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbYGJRcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbYGJRcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:32:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:25206 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbYGJRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nRhulIynf94NCri7adWmsXsawEMArRFiTFbU/mJsUHbcRmI6ios5sWQK/s/2iPPzmJ
         6NpAtZZUQntSOOzVYZ534o8ELGXQF0EDbiwZMdxWmnmlydVwldquz2lD07eS4j+IHA22
         6ZHDUoYl6Ydd4KSV3nXLfuPFeszT9p/SyW9cQ=
Message-ID: <86802c440807101032h6fc6cf16l829e4932477f43b3@mail.gmail.com>
Date: Thu, 10 Jul 2008 10:32:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joe Jin" <joe.jin@oracle.com>
Subject: Re: [PATCH] x86_64: reserve crashkernel bootmem before reserve dma32 bootmem
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <andi@firstfloor.org>,
       greg.marsden@oracle.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080710123446.GA1595@joejin-pc.cn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710123446.GA1595@joejin-pc.cn.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 5:34 AM, Joe Jin <joe.jin@oracle.com> wrote:
> Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
> this cuased crashkernel end address must less than 64M or start address must
> more than 192M except crashkernel memory reserved before dma32 memory reserved.
>
> This patch against 2.6.26-rc9
>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> ---
>  setup_64.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-2.6.26-rc9/arch/x86/kernel/setup_64.c.orig    2008-07-10 16:34:12.000000000 +0800
> +++ linux-2.6.26-rc9/arch/x86/kernel/setup_64.c 2008-07-10 16:35:00.000000000 +0800
> @@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
>        contig_initmem_init(0, end_pfn);
>  #endif
>
> -       dma32_reserve_bootmem();
> -
>  #ifdef CONFIG_ACPI_SLEEP
>        /*
>         * Reserve low memory region for sleep support.
> @@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>        reserve_crashkernel();
>
> +       dma32_reserve_bootmem();
> +
>        reserve_ibft_region();
>
>        paging_init();

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

BTW: current tip/master already make dma32_reserve_bootmem start from 512M
http://people.redhat.com/mingo/tip.git/readme.txt

YH
