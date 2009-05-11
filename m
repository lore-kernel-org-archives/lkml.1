Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZEKDmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZEKDmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZEKDly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:41:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:40171 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZEKDlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:41:53 -0400
Date: Mon, 11 May 2009 12:40:33 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 1/9] xen: make sure swiotlb allocation is physically
 contigious
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241741842-7966-2-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
	<1241741842-7966-2-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511122557D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 12:40:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 May 2009 17:17:14 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Impact: make swiotlb allocation suitable for Xen
> 
> When allocating the swiotlb buffer under Xen, make sure the memory is
> physically contiguous so that its really suitable for DMA.
> 
> Do this by allocating the memory as usual, but then call a Xen
> function to rearrange the underlying pages to be physically
> contiguous.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb.c |   10 ----------
>  arch/x86/xen/Makefile         |    1 +
>  arch/x86/xen/pci-swiotlb.c    |   27 +++++++++++++++++++++++++++
>  drivers/pci/xen-iommu.c       |   16 ++++++++++++++++
>  include/xen/swiotlb.h         |    6 ++++++
>  5 files changed, 50 insertions(+), 10 deletions(-)
>  create mode 100644 arch/x86/xen/pci-swiotlb.c
>  create mode 100644 include/xen/swiotlb.h

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
