Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZD0Sm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZD0Sm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbZD0Smj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:42:39 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54466 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759569AbZD0Smh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:42:37 -0400
Date: Mon, 27 Apr 2009 20:44:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 5/8] powerpc: Use __REF macro instead of old .text.init.refok.
Message-ID: <20090427184446.GE12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu> <1240855347-19316-6-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-6-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:24PM -0400, Tim Abbott wrote:
> The section .text.init.refok is deprecated and __REF (.ref.text)
> should be used in assembly files instead.  This patch cleans up a few
> uses of .text.init.refok in the powerpc architecture.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/powerpc/include/asm/ppc_asm.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
> index f59a666..384d90c 100644
> --- a/arch/powerpc/include/asm/ppc_asm.h
> +++ b/arch/powerpc/include/asm/ppc_asm.h
> @@ -4,6 +4,7 @@
>  #ifndef _ASM_POWERPC_PPC_ASM_H
>  #define _ASM_POWERPC_PPC_ASM_H
>  
> +#include <linux/init.h>
>  #include <linux/stringify.h>
>  #include <asm/asm-compat.h>
>  #include <asm/processor.h>
> @@ -189,7 +190,7 @@ name: \
>  GLUE(.,name):
>  
>  #define _INIT_GLOBAL(name) \
> -	.section ".text.init.refok"; \
> +	__REF; \
>  	.align 2 ; \
>  	.globl name; \
>  	.globl GLUE(.,name); \
> @@ -229,7 +230,7 @@ name: \
>  GLUE(.,name):
>  
>  #define _INIT_STATIC(name) \
> -	.section ".text.init.refok"; \
> +	__REF; \
>  	.align 2 ; \
>  	.section ".opd","aw"; \
>  name: \
> -- 
> 1.6.2.1
> 
