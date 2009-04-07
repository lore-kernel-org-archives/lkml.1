Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbZDGVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbZDGVXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbZDGVXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:23:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120AbZDGVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:23:34 -0400
Date: Tue, 7 Apr 2009 14:11:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Consolidate init_mm definition
Message-Id: <20090407141156.296d0d0c.akpm@linux-foundation.org>
In-Reply-To: <20090326235116.GA26129@x200.localdomain>
References: <20090326235116.GA26129@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 02:51:16 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> --- /dev/null
> +++ b/mm/init-mm.c
> @@ -0,0 +1,13 @@
> +#include <linux/mm_types.h>
> +#include <asm/pgtable.h>
> +
> +struct mm_struct init_mm = {
> +	.mm_rb		= RB_ROOT,
> +	.pgd		= swapper_pg_dir,
> +	.mm_users	= ATOMIC_INIT(2),
> +	.mm_count	= ATOMIC_INIT(1),
> +	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
> +	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
> +	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
> +	.cpu_vm_mask	= CPU_MASK_ALL,
> +};

I'd be more conmfortable if this file were to explicitly include the
headers which it needs.

As it stands, variations in configs (especially different
architectures) have a decent chance of breaking things.

