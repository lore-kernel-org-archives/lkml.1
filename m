Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZCELlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZCELlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZCELkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:40:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZCELkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:40:51 -0500
Date: Thu, 5 Mar 2009 12:40:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] iommu fixes for 2.6.29-rc7
Message-ID: <20090305114032.GB9548@elte.hu>
References: <20090305112215.GB8751@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305112215.GB8751@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
>   Linus Torvalds (1):
>         Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes-2.6.29
> 
> FUJITA Tomonori (1):
>       AMD IOMMU: remove unnecessary ifdef
> 
> Hannes Eder (1):
>       IOMMU-API: use ANSI style function declaration for 'iommu_found'
> 
>  arch/x86/kernel/amd_iommu.c |    2 --
>  drivers/base/iommu.c        |    2 +-
>  2 files changed, 1 insertions(+), 3 deletions(-)
> 
> One fix is for AMD IOMMU and the other one for the IOMMU-API. 
> Please pull.

> 
> Joerg
> 
> Here is the full diff:
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 5113c08..d7a7c4c 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -23,9 +23,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/scatterlist.h>
>  #include <linux/iommu-helper.h>
> -#ifdef CONFIG_IOMMU_API
>  #include <linux/iommu.h>
> -#endif
>  #include <asm/proto.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>

hm, is this one really needed for .29? We are in late-rc freeze 
mode.

> diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> index 5e039d4..c2d1eed 100644
> --- a/drivers/base/iommu.c
> +++ b/drivers/base/iommu.c
> @@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
>  	iommu_ops = ops;
>  }
>  
> -bool iommu_found()
> +bool iommu_found(void)
>  {
>  	return iommu_ops != NULL;
>  }

that's ugly indeed albeit too not critical and not a regression 
fix. My inclination would be to pull for the .30 merge window.

	Ingo
