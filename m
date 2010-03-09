Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0CIBdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:33:15 -0500
Received: from sh.osrg.net ([192.16.179.4]:57354 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab0CIBdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:33:12 -0500
Date: Tue, 9 Mar 2010 10:32:01 +0900
To: bp@amd64.org
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on
 AMD
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100308170637.GA26565@aftab>
References: <20100308170637.GA26565@aftab>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100309103124T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Mar 2010 10:32:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 18:06:37 +0100
Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Mon, 8 Mar 2010 14:27:01 +0100
> Subject: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on AMD
> 
> de957628ce7c84764ff41331111036b3ae5bad0f changed setting of the
> x86_init.iommu.iommu_init function ptr only when GART IOMMU is found.
> 
> One side effect of it is that num_k8_northbridges
> is not initialized anymore if not explicitly
> called. This resulted in uninitialized pointers in
> <arch/x86/kernel/cpu/intel_cacheinfo.c:amd_calc_l3_indices()>,
> for example, which uses the num_k8_northbridges thing through
> node_to_k8_nb_misc().
> 
> Fix that through an initcall that runs right after the PCI subsystem and
> does all the scanning. Then, remove initialization in gart_iommu_init()
> which is a rootfs_initcall and we're running before that.
> 
> What is more, since num_k8_northbridges is being used in other places
> beside GART IOMMU, include it whenever we add AMD CPU support.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Tested-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/Kconfig              |    2 +-
>  arch/x86/kernel/k8.c          |   14 ++++++++++++++
>  arch/x86/kernel/pci-gart_64.c |    2 +-
>  3 files changed, 16 insertions(+), 2 deletions(-)

Thanks a lot!

Looks correct to me.
