Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbXJPC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbXJPC1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbXJPC1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:27:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbXJPC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:27:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=LV/2fbLdyNzx37L+3ctKPnnIJlEXsEIzDzasMR74ujYuUjVql6BWI6LvrS5getJZ+
	jr92WcvZb0jRwvGmvJWUw==
Date: Mon, 15 Oct 2007 19:26:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 2/11] maps3: introduce task_size_of for all arches
In-Reply-To: <1192494989.6118.142.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710151924420.11508@chino.kir.corp.google.com>
References: <3.290135367@selenic.com>  <alpine.DEB.0.9999.0710151643260.18722@chino.kir.corp.google.com> <1192494989.6118.142.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Dave Hansen wrote:

> diff -puN include/asm-mips/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-mips/processor.h
> --- lxc/include/asm-mips/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
> +++ lxc-dave/include/asm-mips/processor.h	2007-10-15 17:34:12.000000000 -0700
> @@ -45,6 +45,8 @@ extern unsigned int vced_count, vcei_cou
>   * space during mmap's.
>   */
>  #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
> +#define TASK_SIZE_OF(tsk)						\
> +	(test_tsk_thread_flag(tak, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
>  #endif
>  
>  #ifdef CONFIG_64BIT

tak needs to be tsk.

> @@ -65,6 +67,8 @@ extern unsigned int vced_count, vcei_cou
>  #define TASK_UNMAPPED_BASE						\
>  	(test_thread_flag(TIF_32BIT_ADDR) ?				\
>  		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
> +#define TASK_SIZE_OF(tsk)						\
> +	(test_tsk_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
>  #endif
>  
>  #define NUM_FPU_REGS	32

test_tsk_thread_flag() takes two arguments.
