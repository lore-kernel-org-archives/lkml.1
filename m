Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbYB2Cq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbYB2Cq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYB2CqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:46:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:18339 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYB2CqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HPxXFTu7xz4nlZW6M2fmfYktUKXEnQy9sdywWtZP16rcUP3z1594azqYB6y+WMd9Q2Qbmdgfc3ns3Zs5xW9ItBTNzeFEWHDFUn/ZZmLHA5ukF2RLKARsuIESfzaCfeDA1C5pu8huTwxLf/h3Vz9DzbS3G3T3uVGPlv3bfKryUhA=
Message-ID: <dc1166600802281846m26865caw677ea9c9bb0722ca@mail.gmail.com>
Date: Fri, 29 Feb 2008 13:46:15 +1100
From: "Michael Ellerman" <michael@ellerman.id.au>
To: akepner@sgi.com
Subject: Re: [PATCH 2/3 v3] dma/ia64: update ia64 machvecs
Cc: "Tony Luck" <tony.luck@intel.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jes Sorensen" <jes@sgi.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "David Miller" <davem@davemloft.net>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080228032541.GT11012@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228032541.GT11012@sgi.com>
X-Google-Sender-Auth: c971df0d0c24217b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:25 PM,  <akepner@sgi.com> wrote:
>
>  Change all ia64 machvecs to use the new dma_{un}map_*_attrs()
>  interfaces. Implement the old dma_{un}map_*() interfaces in
>  terms of the corresponding new interfaces. For ia64/sn, make
>  use of one dma attribute, DMA_ATTR_SYNC_ON_WRITE.
>
>  Signed-off-by: Arthur Kepner <akepner@sgi.com>
>
>  ---
>
>   arch/ia64/hp/common/hwsw_iommu.c         |   61 ++++++++++++-----------
>   arch/ia64/hp/common/sba_iommu.c          |   64 ++++++++++++++-----------
>   arch/ia64/sn/pci/pci_dma.c               |   79 +++++++++++++++++++++----------
>   include/asm-ia64/dma-mapping.h           |   28 +++++++++-
>   include/asm-ia64/machvec.h               |   52 ++++++++++++--------
>   include/asm-ia64/machvec_hpzx1.h         |   16 +++---
>   include/asm-ia64/machvec_hpzx1_swiotlb.h |   16 +++---
>   include/asm-ia64/machvec_sn2.h           |   16 +++---
>   include/linux/dma-attrs.h                |   55 +++++++++++++++++++++
>   lib/swiotlb.c                            |   50 ++++++++++++++++---
>   10 files changed, 300 insertions(+), 137 deletions(-)


This patch would be better off split into generic and arch portions IMHO.

cheers
