Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYA3SjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYA3SjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYA3SjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:39:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48337 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892AbYA3SjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:39:00 -0500
Message-ID: <47A0C441.4020502@sgi.com>
Date: Wed, 30 Jan 2008 10:38:57 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/6] powerpc: Use generic per cpu linux-2.6.git
References: <20080130180940.022172000@sgi.com> <20080130180940.788340000@sgi.com> <20080130182809.GA27168@elte.hu>
In-Reply-To: <20080130182809.GA27168@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> Powerpc has a way to determine the address of the per cpu area of the 
>> currently executing processor via the paca and the array of per cpu 
>> offsets is avoided by looking up the per cpu area from the remote 
>> paca's (copying x86_64).
> 
> i needed the fix below to get my powerpc crosscompile build to succeed.
> 
> 	Ingo

Thanks!  I double-checked the logs and my ppc build worked.  But yes, this was
in the original patch.  And wierdly, powerpc was the only arch that had it
dropped.

-Mike
> 
> -------------->
> Subject: powerpc: percpu build fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-powerpc/percpu.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-x86.q/include/asm-powerpc/percpu.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-powerpc/percpu.h
> +++ linux-x86.q/include/asm-powerpc/percpu.h
> @@ -13,7 +13,7 @@
>  #include <asm/paca.h>
>  
>  #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
> -#define __my_cpu_offset() get_paca()->data_offset
> +#define __my_cpu_offset get_paca()->data_offset
>  #define per_cpu_offset(x) (__per_cpu_offset(x))
>  
>  #endif /* CONFIG_SMP */

