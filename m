Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXEPGez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXEPGez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbXEPGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:34:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXEPGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:34:48 -0400
Date: Tue, 15 May 2007 23:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Slab allocators: Define common size limitations
Message-Id: <20070515233239.335bd4ed.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 23:15:24 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> Currently we have a maze of configuration variables that determine
> the maximum slab size. Worst of all it seems to vary between SLAB and SLUB.
> 
> So define a common maximum size for kmalloc. For conveniences sake
> we use the maximum size ever supported which is 32 MB. We limit the maximum
> size to a lower limit if MAX_ORDER does not allow such large allocations.
> 
> For many architectures this patch will have the effect of adding large
> kmalloc sizes. x86_64 adds 5 new kmalloc sizes. So a small amount
> of memory will be needed for these caches (contemporary SLAB has dynamically
> sizeable node and cpu structure so the waste is less than in the past)
> 
> Most architectures will then be able to allocate object with sizes up to
> MAX_ORDER. We have had repeated breakage (in fact whenever we doubled the
> number of supported processors) on IA64 because one or the other struct
> grew beyond what the slab allocators supported. This will avoid future
> issues and f.e. avoid fixes for 2k and 4k cpu support.
> 
> CONFIG_LARGE_ALLOCS is no longer necessary so drop it.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  arch/blackfin/Kconfig         |    8 --------
>  arch/frv/Kconfig              |    8 --------
>  arch/m68knommu/Kconfig        |    8 --------
>  arch/v850/Kconfig             |    8 --------
>  include/linux/kmalloc_sizes.h |   20 +++++++++++++++-----
>  include/linux/slab.h          |   15 +++++++++++++++
>  include/linux/slub_def.h      |   19 ++-----------------
>  mm/slab.c                     |   19 ++-----------------
>  8 files changed, 34 insertions(+), 71 deletions(-)

rofl. Really we shouldn't put this into 2.6.22, but it turfs out so much
crap that it's hard to justify holding it back.
