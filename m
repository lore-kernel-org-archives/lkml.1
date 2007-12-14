Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXLNPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXLNPqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXLNPqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:46:33 -0500
Received: from gw.goop.org ([64.81.55.164]:37538 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbXLNPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:46:32 -0500
Message-ID: <4762A546.4080602@goop.org>
Date: Fri, 14 Dec 2007 07:46:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
References: <47623AD6.6090403@goop.org> <20071214092816.GA11266@elte.hu>
In-Reply-To: <20071214092816.GA11266@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Unify common definitions in page*.h.  To simplify other code, I added 
>> typedefs for the value of pte/pmd/pud/pgd values, so they can be used 
>> symbolically elsewhere without needing to have lots of 32/64/PAE 
>> tests.
>>
>> Also, add PAGETABLE_LEVELS define so that other definitions can test 
>> for it directly rather than using indirect 32/64/PAE tests.
>>     
>
> this one introduces mass warnings of:
>
>  include/asm/page.h: In function 'copy_page':
>  include/asm/page.h:34: warning: passing argument 2 of 'mmx_copy_page' discards qualifiers from pointer target type
>  In file included from include/asm/thread_info_32.h:14,
>                  from include/asm/thread_info.h:3,
>                  from include/linux/thread_info.h:35,
>                  from include/linux/preempt.h:10,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:5,
>                  from include/linux/mm.h:9,
>                  from arch/x86/mm/mmap.c:29:
>
> with the attached config.
>   

Hm.  I constified the "from" argument to copy_page on the way through
(to catch param-swapping problems).  Looks like I need to update
mmx_copy_page etc as well.  Anyway, this warning is harmless, and I'll
generate a separate patch to fix it.

    J
