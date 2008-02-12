Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYBLTkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYBLTkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYBLTkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:40:06 -0500
Received: from www.tglx.de ([62.245.132.106]:45232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYBLTkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:40:05 -0500
Date: Tue, 12 Feb 2008 20:39:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/8] Implement true end_pfn_mapped for 32bit
In-Reply-To: <20080211093435.E6FC21B41CE@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802122035270.12988@apollo.tec.linutronix.de>
References: <200802111034.764275766@suse.de> <20080211093435.E6FC21B41CE@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:
> Even on 32bit 2MB pages can map more memory than is in the true
> max_low_pfn if end_pfn is not highmem and not aligned to 2MB. 
> Add a end_pfn_map similar to x86-64 that accounts for this 
> fact. This is important for code that really needs to know about
> all mapping aliases. Needed for followup patches (in this case EFI)

It's not only necessary for followup patches, it is a question of
general correctness.

> @@ -36,7 +36,7 @@
>  #define max_pfn_mapped		end_pfn_map
>  #else
>  #include <asm/page_32.h>
> -#define max_pfn_mapped		max_low_pfn
> +#define max_pfn_mapped		end_pfn_map

We can nuke either max_pfn_mapped or end_pfn_map completely. I don't
care about which one, but keeping both makes no sense at all.

Thanks,

	tglx
