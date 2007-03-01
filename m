Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXCAJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXCAJF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933173AbXCAJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:05:28 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:22026 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbXCAJF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:05:26 -0500
Date: Thu, 1 Mar 2007 10:03:48 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Subject: Re: [PATCH 5/5] Move definition of hard_smp_processor_id to asm/smp.h - alpha, m32r, powerpc, s390, sparc, sparc64, um
Message-ID: <20070301090348.GA8405@osiris.boeblingen.de.ibm.com>
References: <1172733503.1498.275.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172733503.1498.275.camel@sebastian.intellilink.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:18:23PM +0900, Fernando Luis Vázquez Cao wrote:
> Move definition of hard_smp_processor_id to asm/smp.h on alpha, m32r,
> powerpc, s390, sparc, sparc64, and um architectures.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.21-rc2/include/asm-alpha/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h
> --- linux-2.6.21-rc2/include/asm-alpha/smp.h	2007-02-05 03:44:54.000000000 +0900
> +++ linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h	2007-03-07 13:34:14.000000000 +0900
> @@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
> 
>  #else /* CONFIG_SMP */
> 
> +#define hard_smp_processor_id()		0
>  #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
> 
>  #endif /* CONFIG_SMP */

/me thinks you should merge this patch with patch 1. Otherwise there is no
hard_smp_processor_id() defined on any architecture if only patch 1 is
applied. That would break a git bisect search.
