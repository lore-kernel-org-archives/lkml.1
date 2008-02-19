Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYBSK60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYBSK60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYBSK6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:58:18 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:42409 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYBSK6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:58:17 -0500
To: davem@davemloft.net
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080217.234142.157527607.davem@davemloft.net>
References: <20080211.214036.154985035.davem@davemloft.net>
	<20080216150341A.tomof@acm.org>
	<20080217.234142.157527607.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080219195758V.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 19 Feb 2008 19:57:58 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 23:41:42 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <tomof@acm.org>
> Date: Sat, 16 Feb 2008 15:03:43 +0900
> 
> > [PATCH] sparc64: make IOMMU code respect the segment boundary limits
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Looks good, but I think it will break sound for some ALI chips.
> 
> Please see arch/sparc64/kernel/pci.c:ali_sound_dma_hack()
> and it's caller pci_dma_supported().

Could you explain the problem a little more?

The shift argument is only used as an offset when iommu-helper decides
whether a memory area (index plus npages) spanning LLD's segment
boudnary size or not.

For example, if a device's segment boudary size is 64K, the helper see
the following value is larger than 64K or not:

((the offset + index of the IOMMU table) ((64K / 8K) - 1) + npages
