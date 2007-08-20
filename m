Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXHTW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXHTW1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXHTW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:27:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXHTW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:27:14 -0400
Message-ID: <46CA1533.2040200@zytor.com>
Date: Mon, 20 Aug 2007 15:26:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shannon Nelson <shannon.nelson@intel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       chris.leech@gmail.com, ak@suse.de, tony.luck@intel.com
Subject: Re: [PATCH -mm] IOAT: fix for UP use of cpu_physical_id()
References: <20070820202908.14306.31248.stgit@localhost.localdomain>
In-Reply-To: <20070820202908.14306.31248.stgit@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shannon Nelson wrote:
> Make sure we can use cpu_physical_id() even when compiled for
> uni-processor.
> 
> diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
> index c3a500b..b1af49c 100644
> --- a/drivers/dma/ioat_dca.c
> +++ b/drivers/dma/ioat_dca.c
> @@ -25,6 +25,14 @@
>  #include <linux/smp.h>
>  #include <linux/interrupt.h>
>  #include <linux/dca.h>
> +
> +// either a kernel change is needed, or we need something like this in kernel
> +#ifndef CONFIG_SMP
> +#include <asm/smp.h>
> +#undef cpu_physical_id
> +#define cpu_physical_id(cpu) (cpuid_ebx(1) >> 24)
> +#endif
> +

This value should probably be cached.  Executing cpuid to get a static
value seems like a bad idea.

	-hpa
