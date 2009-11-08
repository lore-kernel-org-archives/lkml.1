Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZKHMMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZKHMMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZKHMMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:12:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbZKHMMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:12:34 -0500
Date: Sun, 8 Nov 2009 13:12:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: Re: [PATCH] x86: use x86_platform for iommu_shutdown
Message-ID: <20091108121232.GZ11372@elte.hu>
References: <20091027163358F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027163358F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patch cleans up pci_iommu_shutdown() a bit to use x86_platform
> (similar to how IA64 initializes an IOMMU driver).
> 
> This adds iommu_shutdown() to x86_platform to avoid calling every
> IOMMUs' shutdown functions in pci_iommu_shutdown() in order. The IOMMU
> shutdown functions are platform specific (we don't have multiple
> different IOMMU hardware) so the current way is pointless.
> 
> An IOMMU driver sets x86_platform.iommu_shutdown to the shutdown
> function if necessary.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/include/asm/amd_iommu.h |    2 --
>  arch/x86/include/asm/gart.h      |    4 ----
>  arch/x86/include/asm/iommu.h     |    2 +-
>  arch/x86/include/asm/x86_init.h  |    1 +
>  arch/x86/kernel/amd_iommu_init.c |    6 +-----
>  arch/x86/kernel/crash.c          |    5 ++---
>  arch/x86/kernel/pci-dma.c        |    7 -------
>  arch/x86/kernel/pci-gart_64.c    |    6 ++++--
>  arch/x86/kernel/reboot.c         |    4 ++--
>  arch/x86/kernel/x86_init.c       |    2 ++
>  10 files changed, 13 insertions(+), 26 deletions(-)

Applied, thanks - this is a really nice cleanup!

	Ingo
