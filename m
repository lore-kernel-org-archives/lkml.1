Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbXJMJav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbXJMJav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbXJMJaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:30:17 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:58699 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761281AbXJMJaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:30:10 -0400
Date: Sat, 13 Oct 2007 11:30:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dave Jones <davej@redhat.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current Linus' git compilation breakage.
Message-ID: <20071013113006.6494d1d2@hyperion.delvare>
In-Reply-To: <20071013012244.GD18760@redhat.com>
References: <200710131111.32941.nigel@nigel.suspend2.net>
	<20071013012244.GD18760@redhat.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 21:22:44 -0400, Dave Jones wrote:
> On Sat, Oct 13, 2007 at 11:11:31AM +1000, Nigel Cunningham wrote:
>  > Hi all.
>  > 
>  > Maybe I just picked a bad time to try, but...
>  > 
>  > arch/x86/kernel/alternative.c: In function 'apply_alternatives':
>  > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_START' undeclared (first use in this function)
>  > arch/x86/kernel/alternative.c:191: error: (Each undeclared identifier is reported only once
>  > arch/x86/kernel/alternative.c:191: error: for each function it appears in.)
>  > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_END' undeclared (first use in this function)
>  > make[1]: *** [arch/x86/kernel/alternative.o] Error 1
>  > make: *** [arch/x86/kernel] Error 2
> 
> Try this.
> 
> Include missing header for vsyscall.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index bd72d94..11b03d3 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -10,6 +10,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/mce.h>
>  #include <asm/nmi.h>
> +#include <asm/vsyscall.h>
>  
>  #define MAX_PATCH_LEN (255-1)
>  

Fixes the problem for me, thanks Dave!

Acked-by: Jean Delvare <khali@linux-fr.org>

This should be applied to Linus' tree quickly.

-- 
Jean Delvare
