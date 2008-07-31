Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYGaXwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYGaXwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYGaXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:52:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:55711 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYGaXwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:52:39 -0400
Date: Fri, 1 Aug 2008 08:51:23 +0900
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       joerg.roedel@amd.com, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       davem@davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Revert "Merge branch 'x86/iommu' of
 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into
 for-linus"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080801094323.9601d87b.sfr@canb.auug.org.au>
References: <20080801094323.9601d87b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080801085106E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 09:43:23 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> This reverts commit 29111f579f4f3f2a07385f931854ab0527ae7ea5.
> 
> This undoes the hasty addition of a global version of iommu_num_pages()
> that broke both the powerpc and sparc builds.  This function can be
> revisited later.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/kernel/amd_iommu.c   |   13 ++++++++-----
>  arch/x86/kernel/pci-gart_64.c |   11 +++++++----
>  include/linux/iommu-helper.h  |    1 -
>  lib/iommu-helper.c            |    8 --------
>  4 files changed, 15 insertions(+), 18 deletions(-)
> 
> This patch comes from
> git revert -m 1 29111f579f4f3f2a07385f931854ab0527ae7ea5
> 
> I have test built powerpc ppc64_defconfig and sparc64 defconfig.  The only
> references to iommu_num_pages() after this is applied are in the powerpc
> and sparc code.
> 
> Linus, please apply.  This is impacting on both powerpc and sparc
> development and even the author of the patches said that those patches
> were not urgent.

Ingo has a patch to fix this problem in the x86 tree:

http://marc.info/?l=linux-kernel&m=121754062325903&w=2
