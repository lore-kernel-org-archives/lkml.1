Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbYGBEdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbYGBEdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYGBEdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:33:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:43888 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYGBEdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:33:07 -0400
Date: Wed, 2 Jul 2008 13:29:19 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, alexisb@us.ibm.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080701210620.1e90e1fd.akpm@linux-foundation.org>
References: <20080701194840.258b500f.akpm@linux-foundation.org>
	<20080702124328B.fujita.tomonori@lab.ntt.co.jp>
	<20080701210620.1e90e1fd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080702132903E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 21:06:20 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 2 Jul 2008 12:43:39 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > My initial patch has some bugs (wasn't tested because I don't have
> > Calgary hardware) but Alexis fixed the problems and submitted new one
> > (he successfully tested it). I had one minor comment about it then he
> > submitted another one.
> > 
> > http://marc.info/?l=linux-kernel&m=121329005131176&w=2
> > 
> > I think that it can get into mainline with the dma-mapping-per-device
> > patchset.
> > 
> > As we discussed, we could do better but it takes some time. I think
> > that it's better to fix Calgary problems now. Then I'll try to improve
> > dma-mapping-per-device stuff.
> > 
> > Here's a repost of Alexis's latest patch.
> > 
> > Thanks,
> > 
> > =
> > From: Alexis Bruemmer <alexisb@us.ibm.com>
> > Subject: [PATCH] x86 calgary: fix handling of devces that aren't behind the Calgary
> > 
> > The calgary code can give drivers addresses above 4GB which is very
> > bad for hardware that is only 32bit DMA addressable.
> > 
> > With this patch, the calgary code sets the global dma_ops to swiotlb
> > or nommu properly, and the dma_ops of devices behind the
> > Calgary/CalIOC2 to calgary_dma_ops. So the calgary code can handle
> > devices safely that aren't behind the Calgary/CalIOC2.
> > 
> 
> OK..  Looks like this needs to be folded into
> dma-mapping-x86-per-device-dma_mapping_ops-support prior to merging to
> keep everything bisect-happy.

This doesn't need to be fold though it could.

This patch uses per-device-dma_mapping_ops support so this need to be
applied after the per-device-dma_mapping_ops patchset.


> > +		if(translation_enabled(tbl))
> 
> checkpatch?

Oops, sorry about that.
