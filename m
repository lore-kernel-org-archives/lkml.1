Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZEZTVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZEZTVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbZEZTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:21:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbZEZTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:21:37 -0400
Subject: Re: [PATCH] drm: i915: ensure objects are allocated below 4GB on
 PAE
From: Peter Zijlstra <peterz@infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: airlied@redhat.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, eric@anholt.net, stable@kernel.org,
       hugh.dickins@tiscali.co.uk, linux-mm@kvack.org, shaohua.li@intel.com
In-Reply-To: <20090526162717.GC14808@bombadil.infradead.org>
References: <20090526162717.GC14808@bombadil.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 26 May 2009 21:17:53 +0200
Message-Id: <1243365473.23657.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 12:27 -0400, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Ensure we allocate GEM objects below 4GB on PAE machines, otherwise
> misery ensues. This patch is based on a patch found on dri-devel by
> Shaohua Li, but Keith P. expressed reticence that the changes unfairly
> penalized other hardware.
> 
> (The mm/shmem.c hunk is necessary to ensure the DMA32 flag isn't used
>  by the slab allocator via radix_tree_preload, which will hit a
>  WARN_ON.)

Why is this, is the gart not PAE friendly?

Seems to me its a grand way of promoting 64bit hard/soft-ware.
