Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0BYGyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:54:53 -0500
Received: from sh.osrg.net ([192.16.179.4]:39636 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab0BYGyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:54:51 -0500
Date: Thu, 25 Feb 2010 15:53:20 +0900
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com, jeremy@goop.org,
       Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH 02/10] swiotlb: Make 'setup_io_tlb_npages' accept new
 'swiotlb=' syntax.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
	<1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
	<1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100225155242F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 25 Feb 2010 15:53:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 11:26:58 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> The old syntax for 'swiotlb' is still in effect, and we extend it
> now to include the overflow buffer size. The syntax is now:
> 
> swiotlb=[force,][nslabs=<pages>,][overflow=<size>] or more
> commonly know as:
> 
> swiotlb=[force]
> swiotlb=[nslabs=<pages>]
> swiotlb=[overflow=<size>]
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  Documentation/x86/x86_64/boot-options.txt |    6 ++++-
>  lib/swiotlb.c                             |   36 +++++++++++++++++++++++++---
>  2 files changed, 37 insertions(+), 5 deletions(-)

'overflow' is a workaround for broken drivers (that ignores DMA
mapping errors). We have fixed such drivers and other hardware IOMMU
implementations don't have such workaround. So please don't extend
it. We should remove it instead.
