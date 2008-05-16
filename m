Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYEPIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYEPIVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYEPIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:20:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60020 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYEPIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:20:57 -0400
Subject: Re: [patch 1/5] access_process_vm device memory infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ajackson@redhat.com, airlied@redhat.com, benh@kernel.crashing.org
In-Reply-To: <20080515175431.000301639@redhat.com>
References: <20080515175357.636334082@redhat.com>
	 <20080515175431.000301639@redhat.com>
Content-Type: text/plain
Date: Fri, 16 May 2008 10:20:49 +0200
Message-Id: <1210926049.7886.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 13:53 -0400, Rik van Riel wrote:
> plain text document attachment
> (01-access_process_vm-device-memory.patch)
> Add the generic_access_phys access function and put the hooks in place
> to allow access_process_vm to access device or PPC Cell SPU memory.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Benjamin Herrensmidt <benh@kernel.crashing.org>
> 

> Index: ptrace-2.6.26-rc2-mm1/include/linux/mm.h
> ===================================================================
> --- ptrace-2.6.26-rc2-mm1.orig/include/linux/mm.h	2008-05-15 13:50:13.000000000 -0400
> +++ ptrace-2.6.26-rc2-mm1/include/linux/mm.h	2008-05-15 13:50:18.000000000 -0400
> @@ -169,6 +169,12 @@ struct vm_operations_struct {
>  	/* notification that a previously read-only page is about to become
>  	 * writable, if an error is returned it will cause a SIGBUS */
>  	int (*page_mkwrite)(struct vm_area_struct *vma, struct page *page);
> +
> +	/* called by access_process_vm when get_user_pages() fails, typically
> +	 * for use by special VMAs that can switch between memory and hardware
> +	 */
> +	int (*access)(struct vm_area_struct *vma, unsigned long addr,
> +		      void *buf, int len, int write);


This bit misses corresponding Documentation/ changes.

Other than that it looks good.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

