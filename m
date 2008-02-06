Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbYBFXyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbYBFXyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:54:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbYBFXxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:53:50 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:48829 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYBFXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:53:49 -0500
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080206.151855.136436571.davem@davemloft.net>
References: <20080205.204138.107606929.davem@davemloft.net>
	<20080207081236V.fujita.tomonori@lab.ntt.co.jp>
	<20080206.151855.136436571.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080207085333Q.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 07 Feb 2008 08:53:33 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 15:18:55 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 07 Feb 2008 08:12:36 +0900
> 
> > Really sorry about it.
> 
> I am happy to test patches you send to me in the future :-)

Thanks a lot.


> > PARISC, Alpha, and IA64 IOMMUs use the two-pass algorithm like SPARC
> > but their first pass decides how to merge sg entires (and stores that
> > information in the sg entries), then the second pass simpliy follows
> > it (Hopefully I understand these IOMMUs correctly, or else I break
> > them too).
> 
> For now I've removed all of the merging code from the sparc64 IOMMU
> support so that other users do not get corrupt filesystems.  It
> basically mimicks how the intel-iommu code works, ie. no attempts to
> merge anything.

I've just saw it.


> I intend to put merging back in, perhaps something similar to
> powerpc's merging logic but without the expensive (in my opinion)
> IOMMU allocation every loop.  I think it is better to determine the
> segment breaks in one pass, allocate that many IOMMU entries in one
> allocation, then fill them all in.

I thought about asking you if I can modify the SPARC IOMMUs to do
allocation in every loop.

The reason why I need the allocation in every loop is that I also need
to fix the problem that IOMMUs allocate memory areas without
considering a low level driver's segment boundary limits.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg07616.html
http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-12/msg02286.html

As far as I know, all the IOMMUs except for SPARC allocate a free area
in every loop but if it's too expensive for SPARC, then we need to
find a different way to handle segment boundary limits.


> Ideally, we should have some generic code that does all of this.
> Then you would only need to test one implementation.
> 
> It is definitely doable and increasingly necessary as we have so
> many reimplementations of what is essentially identical core code.

Agreed though it's a very hard task.
