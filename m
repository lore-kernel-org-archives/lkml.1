Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYCVAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYCVAET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYCVAEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:04:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:52938 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYCVAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EvnE/k/X5ArDNf3X7km2/nz6lnyekMfZddYS/HMsrj7WSOt6MVpgufgO/A22zIMS7x1C0uaFkJltA3h3dbrAO7QtDGMNciurPXYlm9m4n/AtvgHaw5KU9yXXoH//qoM7lXcQn81SZgWaeNxWF33a/5ETRuqyfvNyhlZfGirkiug=
Message-ID: <86802c440803211704u4fb07074w934f32d2f95bf6a7@mail.gmail.com>
Date: Fri, 21 Mar 2008 17:04:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080321120313.GD25225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080321120313.GD25225@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 5:03 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > do simple memtest after init_memory_mapping
>  >
>  > use find_e820_area_size to find all ram range that is not reserved.
>  >
>  > and do some simple bits test to find some bad ram.
>  >
>  > if find some bad ram, use reserve_early to exclude that range.
>
>  very nice patch! I always thought that this was the proper way to do
>  memtest - and we could in fact also do something like this after SMP
>  bringup, and hit the memory bus via multiple CPUs. [that will need a
>  different enumeration though than e820 maps]
or
1. core0/node0 check all memory at first
2. every core0 will check all memory later one by one.

>
>  one structural observation: please make this unified functionality, so
>  that 32-bit kernels can make use of it too.

that will need to use PAE to switch 2G windows ....

>
>  a small style nit from scripts/checkpatch.pl:
>
>
>  > +//           printk(KERN_DEBUG "find_e820_area_size : e820 %d [%llx, %lx]\n", i, ei->addr, ei_last);
>
>  remove such lines or make them pr_debug(). (checkpatch also found more
>  such cases)
>
>  also, please add a CONFIG_BOOTPARAM_MEMTEST=y option so that
>  distributions can enable this by default in their debug kernels.
>
>  i've applied your current version to get some testing, please send delta
>  patches against x86/latest.

thanks. will submit delta patch.

YH
