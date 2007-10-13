Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXJMLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXJMLTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXJMLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:19:45 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:33586 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXJMLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:19:44 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: Current Linus' git compilation breakage.
Date: Sat, 13 Oct 2007 21:19:34 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200710131111.32941.nigel@nigel.suspend2.net> <20071013012244.GD18760@redhat.com>
In-Reply-To: <20071013012244.GD18760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132119.36082.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave et al.

On Saturday 13 October 2007 11:22:44 Dave Jones wrote:
> On Sat, Oct 13, 2007 at 11:11:31AM +1000, Nigel Cunningham wrote:
>  > Hi all.
>  > 
>  > Maybe I just picked a bad time to try, but...
>  > 
>  > arch/x86/kernel/alternative.c: In function 'apply_alternatives':
>  > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_START' undeclared 
(first use in this function)
>  > arch/x86/kernel/alternative.c:191: error: (Each undeclared identifier is 
reported only once
>  > arch/x86/kernel/alternative.c:191: error: for each function it appears 
in.)
>  > arch/x86/kernel/alternative.c:191: error: 'VSYSCALL_END' undeclared 
(first use in this function)
>  > make[1]: *** [arch/x86/kernel/alternative.o] Error 1
>  > make: *** [arch/x86/kernel] Error 2
> 
> Try this.
> 
> Include missing header for vsyscall.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Thanks.

Compile-Tested-by: Nigel Cunningham <ncunning@redhat.com>

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
