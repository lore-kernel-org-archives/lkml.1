Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYDCCXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYDCCXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYDCCXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:23:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758507AbYDCCXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:23:34 -0400
Date: Wed, 2 Apr 2008 19:22:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>, michael@ellerman.id.au,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: make mem_map allocation continuous v2.
Message-Id: <20080402192223.5e8754a0.akpm@linux-foundation.org>
In-Reply-To: <200804021830.24563.yhlu.kernel@gmail.com>
References: <200804021525.48799.yhlu.kernel@gmail.com>
	<20080402155247.5e746be7.akpm@linux-foundation.org>
	<86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
	<200804021830.24563.yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 18:30:24 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> v2 replace:
> 	[PATCH] mm: make mem_map allocation continuous.
> 	[PATCH] mm: allocate section_map for sparse_init
> 	[PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
> 

err, no.

> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index f6a43c0..2881222 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c

Sorry, but I'd rather not do it this way.  We presently have this:

mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch

and you purport to throw some of them away and combine them into a single
patch?  We assume that the later patches will still apply and work on top
of this newer patch?  It is up to me to check that the replacement patch
incorporates the third-party changes to the original patches?

Too hard, too risky.  Can't we just do a fix against 2.6.25-rc8-mm1?
