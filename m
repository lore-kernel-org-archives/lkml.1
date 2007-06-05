Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbXFEXkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbXFEXkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbXFEXj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:39:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933172AbXFEXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:39:55 -0400
Date: Tue, 5 Jun 2007 16:39:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 3/4] mm: move_page_tables{,_up}
Message-Id: <20070605163920.8066af33.akpm@linux-foundation.org>
In-Reply-To: <20070605151203.738393000@chello.nl>
References: <20070605150523.786600000@chello.nl>
	<20070605151203.738393000@chello.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 17:05:26 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Provide functions for moving page tables upwards.
> 
> ...
>
> +extern unsigned long move_page_tables(struct vm_area_struct *vma,
> +		unsigned long old_addr, struct vm_area_struct *new_vma,
> +		unsigned long new_addr, unsigned long len);
> +extern unsigned long move_page_tables_up(struct vm_area_struct *vma,
> +		unsigned long old_addr, struct vm_area_struct *new_vma,
> +		unsigned long new_addr, unsigned long len);
>  extern unsigned long do_mremap(unsigned long addr,
>  			       unsigned long old_len, unsigned long new_len,
>  			       unsigned long flags, unsigned long new_addr);

They become kernel-wide

> +static void move_ptes_up(struct vm_area_struct *vma, pmd_t *old_pmd,
> +		unsigned long old_addr, unsigned long old_end,
> +		struct vm_area_struct *new_vma, pmd_t *new_pmd,
> +		unsigned long new_addr)

So some documentation might be in order...

