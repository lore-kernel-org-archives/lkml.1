Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbZEGNj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbZEGNj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbZEGNiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:15 -0400
Received: from 8bytes.org ([88.198.83.132]:38419 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZEGNiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:08 -0400
Date: Thu, 7 May 2009 15:38:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH -tip 0/5] add generic dma-mappig.h
Message-ID: <20090507133805.GA13708@8bytes.org>
References: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:35:43PM +0900, FUJITA Tomonori wrote:
> We unified x86 and IA64's handling of multiple dma mapping operations
> (struct dma_map_ops in linux/dma-mapping.h) so we can remove
> duplication in their arch/include/asm/dma-mapping.h.
> 
> This patchset adds include/asm-generic/dma-mapping.h that provides
> some generic dma mapping function definitions for the users of struct
> dma_map_ops. This enables us to remove about 100 lines. This also
> enables us to easily add CONFIG_DMA_API_DEBUG support, which only x86
> supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support to
> IA64 by adding only 8 lines.
> 
> This is against tip/master since tip has some changes to
> arch/x86/include/asm/dma-mapping.h.
> 
> =
>  arch/ia64/Kconfig                   |    1 +
>  arch/ia64/include/asm/dma-mapping.h |  110 ++------------------
>  arch/x86/Kconfig                    |    1 +
>  arch/x86/include/asm/dma-mapping.h  |  174 +-------------------------------
>  include/asm-generic/dma-mapping.h   |  190 +++++++++++++++++++++++++++++++++++
>  lib/dma-debug.c                     |   82 +++++++++------
>  6 files changed, 252 insertions(+), 306 deletions(-)

Patchset looks good to me. As a follow-up work we should try to unify
the *_coherent functions too.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
