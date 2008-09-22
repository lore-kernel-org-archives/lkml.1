Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYIVOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYIVOqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYIVOqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:46:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYIVOqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:46:15 -0400
Date: Mon, 22 Sep 2008 16:46:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off
	instead of amd_iommu=off"
Message-ID: <20080922144601.GA27956@elte.hu>
References: <20080922223457W.fujita.tomonori@lab.ntt.co.jp> <20080922140749.GY24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922140749.GY24392@amd.com>
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

> >     x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off
> > 
> >     This patch removes the amd_iommu=off kernel parameter and honors 
> >     the generic
> > 
> >     iommu=off parameter for the same purpose.
> > 
> > 
> > The above commit is wrong.
> 
> It isn't. The user normally don't care about the type of IOMMU in the 
> system. So disabling it with iommu=off is the right way. To achieve 
> what you want its better to add iommu=gart and iommu=amd to the option 
> parser. This will be consistent with Calgary and SWIOTLB too.

well, what matters in the end is to have a consistent set of exclusion 
options:

  gart_iommu=off     # disable the GART (and only that one)
  intel_iommu=off    # disable the Intel IOMMU (and only that one)
  amd_iommu=off      # disable AMD-IOMMU (and only that one)

then there's the all-off option:

  iommu=off          # wildcard: disable all IOMMUs

[ whether iommu=off also disables the swiotlb is a detail. ]

and we could also do the inclusive options in addition:

  iommu=gart         # use the GART as the primary IOMMU [if available]
  iommu=amd          # use the AMD-IOMMU as the primary IOMMU [if available]
  iommu=intel        # use the Intel IOMMU [if available]

so could we please first agree on such a specific list of generic 
options, and then implement them consistently, while keeping legacies 
(the ones that matter) intact as well?

	Ingo
