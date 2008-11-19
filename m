Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKSGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKSGP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYKSGPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:15:50 -0500
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:44925 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYKSGPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:15:49 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 01:15:49 EST
Date: Wed, 19 Nov 2008 15:05:24 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081118154322.GX13394@amd.com>
References: <20081118154322.GX13394@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119150504G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 16:43:22 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Joerg Roedel (4):
>       AMD IOMMU: add parameter to disable device isolation
>       AMD IOMMU: enable device isolation per default
>       AMD IOMMU: fix fullflush comparison length
>       AMD IOMMU: check for next_bit also in unmapped area
> 
>  Documentation/kernel-parameters.txt |    4 +++-
>  arch/x86/kernel/amd_iommu.c         |    2 +-
>  arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> As the most important change these patches enable device isolation per
> default. Tests have shown that there are drivers which have bugs and do
> double-freeing of DMA memory.

What drivers? We need to fix them if they are mainline drivers.


> This can lead to data corruption with a
> hardware IOMMU when multiple devices share the same protection domain.
> Therefore device isolation should be enabled by default.

Hmm, the change is just because of the bug workaround? If so, I'm not
sure it's a good idea. We need to fix the buggy drivers anyway. And
device isolation is not free; e.g. use more memory rather than sharing
a protection domain. I guess that more people prefer sharing a
protection domain by default. It had been the default option for AMD
IOMMU until you hit the bugs. IIRC, VT-d also shares a protection
domain by default. It would be nice to avoid surprising users if the
two virtualization IOMMUs works in the similar way.
