Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbZIRFhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbZIRFhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZIRFhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:37:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41152
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbZIRFhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:37:06 -0400
Date: Thu, 17 Sep 2009 22:37:23 -0700 (PDT)
Message-Id: <20090917.223723.07032792.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64 pcpu failures...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090917.221807.208354411.davem@davemloft.net>
References: <20090917.221807.208354411.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 17 Sep 2009 22:18:07 -0700 (PDT)

> 
> Tejun, I just started seeing the following on sparc64:
> 
> [   56.422005] WARNING: at mm/vmalloc.c:1991 pcpu_get_vm_areas+0x1b4/0x5fc()
 ...
> Might this be a result of:
> 
> commit bcb2107fdbecef3de55d597d23453747af81ba88
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Aug 14 15:00:53 2009 +0900
> 
>     sparc64: use embedding percpu first chunk allocator
>     
>     sparc64 currently allocates a large page for each cpu and partially
>     remap them into vmalloc area much like what lpage first chunk
>     allocator did.  As a 4M page is used for each cpu, this results in
>     very large unit size and also adds TLB pressure due to the double
>     mapping of pages in the first chunk.
>     
>     This patch converts sparc64 to use the embedding percpu first chunk
>     allocator which now knows how to handle NUMA configurations.  This
>     simplifies the code a lot, doesn't incur any extra TLB pressure and
>     results in better utilization of address space.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Acked-by: David S. Miller <davem@davemloft.net>
> 
> Do you think?

I've verified that reverting this makes the problem go away.
