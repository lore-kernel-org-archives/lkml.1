Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXB0U14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXB0U14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXB0U1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:27:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXB0U1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:27:46 -0500
Date: Tue, 27 Feb 2007 12:27:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: akuster <akuster@mvista.com>
Cc: ioe-lkml@rameria.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] MM:  detach_vmas_to_be_unmapped fix
Message-Id: <20070227122727.3bc61fbf.akpm@linux-foundation.org>
In-Reply-To: <45DF15D4.6040403@mvista.com>
References: <20070221180742.A05F31C49A@hermes.mvista.com>
	<200702212159.07295.ioe-lkml@rameria.de>
	<45DF15D4.6040403@mvista.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 08:27:00 -0800 akuster <akuster@mvista.com> wrote:
> Wolfgang Wander submitted a fix to address a mmap fragmentation issue. 
> The git patch ( 1363c3cd8603a913a27e2995dccbd70d5312d8e6 ) is somewhat 
> different and yields different results when running Wolfgang's test case 
> leakme.c.
> 
> IMHO, the vm start and end address are swapped in arch_unmap_area and 
> arch_unmap_area_topdown functions.
> 
> Prior to this patch arch_unmap_area() used area->vm_start and 
> arch_unmap_area_topdown used area->vm_end in the git patch the following 
> change showed up.
> 
> if (mm->unmap_area == arch_unmap_area)
>      addr = prev ? prev->vm_start : mm->mmap_base;
> else
>      addr = vma ?  vma->vm_end : mm->mmap_base;
> 
> Using Wolfgang Wander's leakme.c test, I get the same results seen with 
> his original "Avoiding mmap fragmentation" patch as I do after swapping 
>   the start & end address in the above code segment. The patch I 
> submitted  addresses this typo issue.

That's still not an adequate or terribly useful changlog, sorry.

Please tell us exactly what this patch does, without referring to some other
patch which I cannot remember nor presently access.

I particular, before-and-after testing results would be useful so we can
see what the effect of this change is.

Also, please send a Signed-of-by: for this work, thanks.
