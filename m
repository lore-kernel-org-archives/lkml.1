Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZDXBRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZDXBRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZDXBRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:17:07 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:47595 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbZDXBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:17:05 -0400
Message-ID: <49F1130D.5080804@snapgear.com>
Date: Fri, 24 Apr 2009 11:17:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: remove PT_DTRACE from m68k, m68knommu
References: <20090423193211.GA14892@redhat.com>
In-Reply-To: <20090423193211.GA14892@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg Nesterov wrote:
> m68k sets PT_DTRACE in trap_c() but never uses it.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>


>  arch/m68k/kernel/traps.c            |    1 -
>  arch/m68knommu/kernel/asm-offsets.c |    1 -
>  arch/m68knommu/kernel/traps.c       |    1 -
>  3 files changed, 3 deletions(-)
> 
> --- PTRACE/arch/m68k/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
> +++ PTRACE/arch/m68k/kernel/traps.c	2009-04-22 21:52:23.000000000 +0200
> @@ -1057,7 +1057,6 @@ asmlinkage void trap_c(struct frame *fp)
>  	if (fp->ptregs.sr & PS_S) {
>  		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
>  			/* traced a trapping instruction */
> -			current->ptrace |= PT_DTRACE;
>  		} else
>  			bad_super_trap(fp);
>  		return;
> --- PTRACE/arch/m68knommu/kernel/asm-offsets.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
> +++ PTRACE/arch/m68knommu/kernel/asm-offsets.c	2009-04-22 21:53:46.000000000 +0200
> @@ -79,7 +79,6 @@ int main(void)
>  	DEFINE(TRAP_TRACE, TRAP_TRACE);
>  
>  	DEFINE(PT_PTRACED, PT_PTRACED);
> -	DEFINE(PT_DTRACE, PT_DTRACE);
>  
>  	DEFINE(THREAD_SIZE, THREAD_SIZE);
>  
> --- PTRACE/arch/m68knommu/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
> +++ PTRACE/arch/m68knommu/kernel/traps.c	2009-04-22 21:54:29.000000000 +0200
> @@ -200,7 +200,6 @@ asmlinkage void trap_c(struct frame *fp)
>  	if (fp->ptregs.sr & PS_S) {
>  		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
>  			/* traced a trapping instruction */
> -			current->ptrace |= PT_DTRACE;
>  		} else
>  			bad_super_trap(fp);
>  		return;
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
