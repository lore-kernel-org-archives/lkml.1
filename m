Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbXGDUoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbXGDUoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXGDUny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:43:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:46743 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXGDUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AB5czeeysA7ULujqcz2XFjD1SAmBTP3/JW9hcnoOeIWDurQmeROHLDTIyxZm1qVBinlmq2J7WWbNI2rL04pOlhCPHK0pJMl0qqGb1NLrqSbMkB7Tutlu9oxoO0nTNgSgnRgrFoo8KWGJk9ODw1N4BBm+dhT0go9Rp7tZIsZ+SE4=
Date: Thu, 5 Jul 2007 00:43:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/10] F00F bug fixup for i386 - use immediate values
Message-ID: <20070704204347.GD5812@martell.zuzino.mipt.ru>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.075810998@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703164516.075810998@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:40:55PM -0400, Mathieu Desnoyers wrote:
> Use the faster immediate values for F00F bug handling in do_page_fault.

> --- linux-2.6-lttng.orig/arch/i386/mm/fault.c
> +++ linux-2.6-lttng/arch/i386/mm/fault.c
> @@ -25,6 +25,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/uaccess.h>
>  #include <linux/kdebug.h>
> +#include <linux/immediate.h>
>  
>  #include <asm/system.h>
>  #include <asm/desc.h>
> @@ -477,7 +478,7 @@
>  	/*
>  	 * Pentium F0 0F C7 C8 bug workaround.
>  	 */
> -	if (boot_cpu_data.f00f_bug) {
> +	if (unlikely(immediate(f00f_bug_fix))) {

As I understand it, this never triggers in normal valid and invalid
pagefaults, because even invalid userspace pagefaults take branch
slightly earlier where catch SIGSEGV. Nobody cares about performance if
you reach this branch.

