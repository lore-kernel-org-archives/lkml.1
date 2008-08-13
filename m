Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYHMAUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYHMAUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYHMAUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:20:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbYHMAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:19:59 -0400
Date: Tue, 12 Aug 2008 17:14:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, hugh@veritas.com,
       balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 0/2] Memory rlimit fix crash on fork
Message-Id: <20080812171407.2f468729.akpm@linux-foundation.org>
In-Reply-To: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 15:37:19 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> --- linux-2.6.27-rc1/mm/memory.c~memrlimit-fix-crash-on-fork	2008-08-11 14:57:48.000000000 +0530
> +++ linux-2.6.27-rc1-balbir/mm/memory.c	2008-08-11 14:58:33.000000000 +0530
> @@ -901,8 +901,12 @@ unsigned long unmap_vmas(struct mmu_gath

^^ returns a long.

>  	unsigned long start = start_addr;
>  	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
>  	int fullmm = (*tlbp)->fullmm;
> -	struct mm_struct *mm = vma->vm_mm;
> +	struct mm_struct *mm;
> +
> +	if (!vma)
> +		return;

^^ mm/memory.c:907: warning: 'return' with no value, in function returning non-void

How does this happen?

I'll drop the patch.  The above mystery change needs a comment, IMO.
