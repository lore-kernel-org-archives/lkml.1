Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0BITxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:53:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab0BITxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:53:16 -0500
Date: Tue, 9 Feb 2010 11:52:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/35] x86: print out for RAM buffer
Message-Id: <20100209115213.dc85e4a5.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-10-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-10-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:20 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> so could check that early in bootlog
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> ---
>  arch/x86/kernel/e820.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index a966b75..dfb1689 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1429,6 +1429,9 @@ void __init e820_reserve_resources_late(void)
>  			end = MAX_RESOURCE_SIZE;
>  		if (start >= end)
>  			continue;
> +		printk(KERN_DEBUG "reserve RAM buffer: %016Lx - %016Lx ",
> +			       (unsigned long long) start,
> +			       (unsigned long long) end);
>  		reserve_region_with_split(&iomem_resource, start, end,
>  					  "RAM buffer");
>  	}

The typecasts for printing u64's are unneeded within x86 code.  In fact
I think they're now unneeded on all architectures.

