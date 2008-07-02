Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYGBEKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYGBEKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYGBEJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:09:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYGBEJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:09:58 -0400
Date: Tue, 1 Jul 2008 21:06:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alexisb@us.ibm.com, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
Message-Id: <20080701210620.1e90e1fd.akpm@linux-foundation.org>
In-Reply-To: <20080702124328B.fujita.tomonori@lab.ntt.co.jp>
References: <1214949124.6553.9.camel@alexis>
	<20080702113711Y.fujita.tomonori@lab.ntt.co.jp>
	<20080701194840.258b500f.akpm@linux-foundation.org>
	<20080702124328B.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 12:43:39 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> My initial patch has some bugs (wasn't tested because I don't have
> Calgary hardware) but Alexis fixed the problems and submitted new one
> (he successfully tested it). I had one minor comment about it then he
> submitted another one.
> 
> http://marc.info/?l=linux-kernel&m=121329005131176&w=2
> 
> I think that it can get into mainline with the dma-mapping-per-device
> patchset.
> 
> As we discussed, we could do better but it takes some time. I think
> that it's better to fix Calgary problems now. Then I'll try to improve
> dma-mapping-per-device stuff.
> 
> Here's a repost of Alexis's latest patch.
> 
> Thanks,
> 
> =
> From: Alexis Bruemmer <alexisb@us.ibm.com>
> Subject: [PATCH] x86 calgary: fix handling of devces that aren't behind the Calgary
> 
> The calgary code can give drivers addresses above 4GB which is very
> bad for hardware that is only 32bit DMA addressable.
> 
> With this patch, the calgary code sets the global dma_ops to swiotlb
> or nommu properly, and the dma_ops of devices behind the
> Calgary/CalIOC2 to calgary_dma_ops. So the calgary code can handle
> devices safely that aren't behind the Calgary/CalIOC2.
> 

OK..  Looks like this needs to be folded into
dma-mapping-x86-per-device-dma_mapping_ops-support prior to merging to
keep everything bisect-happy.

> +		if(translation_enabled(tbl))

checkpatch?


btw, x86_64 allmodconfig says:

arch/x86/kernel/pci-calgary_64.c: In function 'build_detail_arrays':
arch/x86/kernel/pci-calgary_64.c:1263: warning: comparison is always false due t

which is

	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES){

so I'll cancel that order for a 512-node Calgary machine ;)
