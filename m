Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZC0OZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZC0OZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZC0OZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:25:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZC0OZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:25:48 -0400
Date: Fri, 27 Mar 2009 15:22:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 2/14] x86, mm: add release_locked_buffer_on_behalf
Message-ID: <20090327142215.GC14504@redhat.com>
References: <20090327094836.A11033@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327094836.A11033@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Markus Metzger wrote:
>
> -void release_locked_buffer(void *buffer, size_t size)
> +void release_locked_buffer_on_behalf(struct mm_struct *mm,
> +				     void *buffer, size_t size)
>  {
>  	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
>  
> -	down_write(&current->mm->mmap_sem);
> +	down_write(&mm->mmap_sem);
>  
> -	current->mm->total_vm  -= pgsz;
> -	current->mm->locked_vm -= pgsz;
> +	mm->total_vm  -= pgsz;
> +	mm->locked_vm -= pgsz;
>  
> -	up_write(&current->mm->mmap_sem);
> +	up_write(&mm->mmap_sem);
>  }

If you change this helper, perhaps you can remove the "void *buffer"
argument? It is not used. Actually, this helper should be renamed.
It doesn't free the memory, it only updates mm->xxx_vm.

Oleg.

