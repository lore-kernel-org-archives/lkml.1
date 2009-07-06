Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZGFK6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZGFK6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZGFK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:58:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63802 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbZGFK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:58:45 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
	allocator
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 06 Jul 2009 11:58:40 +0100
Message-Id: <1246877921.16785.26.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 10:58:41.0966 (UTC) FILETIME=[B96A2CE0:01C9FE28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> This patch adds kmemleak_alloc/free callbacks to the bootmem allocator.
> This would allow scanning of such blocks and help avoiding a whole class
> of false positives and more kmemleak annotations.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/bootmem.c |   36 +++++++++++++++++++++++++++++-------
>  1 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index d2a9ce9..18858ad 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -335,6 +335,8 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  {
>  	unsigned long start, end;
>  
> +	kmemleak_free(__va(physaddr));

This should actually be

+	kmemleak_free_part(__va(physaddr), size);

-- 
Catalin

