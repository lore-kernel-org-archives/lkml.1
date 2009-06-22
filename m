Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZFVDLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZFVDLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZFVDLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:11:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:35993 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFVDLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:11:23 -0400
Date: Mon, 22 Jun 2009 12:11:12 +0900
To: sfr@canb.auug.org.au
Cc: rdreier@cisco.com, general@lists.openfabrics.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: linux-next: origin tree build warning
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090622110113.7cd89382.sfr@canb.auug.org.au>
References: <20090622110113.7cd89382.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090622121054K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 22 Jun 2009 12:11:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 11:01:13 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> drivers/infiniband/hw/mthca/mthca_mr.c: In function 'mthca_arbel_write_mtt_seg':
> drivers/infiniband/hw/mthca/mthca_mr.c:358: warning: 'dma_sync_single' is deprecated (declared at /scratch/sfr/next/include/linux/dma-mapping.h:113)
> drivers/infiniband/hw/mthca/mthca_mr.c: In function 'mthca_arbel_map_phys_fmr':
> drivers/infiniband/hw/mthca/mthca_mr.c:810: warning: 'dma_sync_single' is deprecated (declared at /scratch/sfr/next/include/linux/dma-mapping.h:113)
> 
> Introduced by commit dbe6f1869188b6e04e38aa861dd198befb08bcd7
> ("dma-mapping: mark dma_sync_single and dma_sync_sg as deprecated").

Thanks, here's a fix for this:

http://marc.info/?l=linux-kernel&m=124347325819016&w=2


The patch doesn't change the driver functionally but the driver looks
broken wrt DMA synchronization. I guess that this issue is on Roland's
todo list:

http://marc.info/?l=linux-kernel&m=124354923710600&w=2
