Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZALTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZALTJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZALTJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:09:28 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47864 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756510AbZALTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:09:25 -0500
Message-ID: <496B9562.8040601@sgi.com>
Date: Mon, 12 Jan 2009 11:09:22 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: include apicnum.h in acpidef.h
References: <496AD835.6000509@kernel.org>
In-Reply-To: <496AD835.6000509@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: clean up
> 
> it seems Ingo revert it wrongly.
> put it back again
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/apicdef.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/apicdef.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/apicdef.h
> +++ linux-2.6/arch/x86/include/asm/apicdef.h
> @@ -132,12 +132,7 @@
>  #define APIC_BASE_MSR	0x800
>  #define X2APIC_ENABLE	(1UL << 10)
>  
> -#ifdef CONFIG_X86_32
> -# define MAX_IO_APICS 64
> -#else
> -# define MAX_IO_APICS 128
> -# define MAX_LOCAL_APIC 32768
> -#endif
> +#include <asm/apicnum.h>
>  
>  /*
>   * All x86-64 systems are xAPIC compatible.

Hi Yinghai,

Actually, Ingo got it right.  I had introduced the apicnum.h file to
get around header entanglements.  But as Ingo pointed out, I did the
include file chain wrong, so removing the apicnum.h file seemed to be
the correct thing to do.  (I just haven't figured out yet how to remove
a file via email patch.  I was just going to clean it up next time I
pushed changes to Ingo.)

Thanks,
Mike


