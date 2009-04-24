Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZDXKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZDXKGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZDXKGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:06:46 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58777 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZDXKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:06:45 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
X-Yow: Wait..  is this a FUN THING or the END of LIFE in Petticoat Junction??
Date: Fri, 24 Apr 2009 12:06:32 +0200
In-Reply-To: <20090423193211.GA14892@redhat.com> (Oleg Nesterov's message of
	"Thu, 23 Apr 2009 21:32:11 +0200")
Message-ID: <m2tz4e5psn.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> m68k sets PT_DTRACE in trap_c() but never uses it.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
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

This is supposed to be setting the TIF_DELAYED_TRACE thread flag.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
