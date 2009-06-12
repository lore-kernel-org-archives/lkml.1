Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZFLNgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZFLNgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763679AbZFLN3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:29:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbZFLN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:29:45 -0400
Subject: Re: [PATCH 3/8] x86: Remove .dynbss from the vDSO linker script
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <8de6230206ca20a4c205066fd213bbc951dbfac6.1244812577.git.ptesarik@suse.cz>
References: <cover.1244812577.git.ptesarik@suse.cz>
	 <8de6230206ca20a4c205066fd213bbc951dbfac6.1244812577.git.ptesarik@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Fri, 12 Jun 2009 15:29:46 +0200
Message-Id: <1244813386.5377.3.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik píše v Pá 12. 06. 2009 v 15:25 +0200:
> As far as I can see, the .dynbss section does not make any sense
> and cannot even appear in a shared library.
> 
> Remove it.

Argh, this commit was wrong. But it changes the context for some of the
following patches. :/ I'll just send the whole patch series again.

Sorry.

Petr Tesarik

> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> ---
>  arch/x86/vdso/vdso-layout.lds.S |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
> index af3fa61..0386c92 100644
> --- a/arch/x86/vdso/vdso-layout.lds.S
> +++ b/arch/x86/vdso/vdso-layout.lds.S
> @@ -46,15 +46,12 @@ SECTIONS
>  	} :text :dynamic
>  
>  	.rodata : {
> -		*(.rodata*)
> +		*(.rodata* .gnu.linkonce.r.*)
>  	} :text
>  	.data : {
> -		*(.data*)
> +		*(.data* .gnu.linkonce.d.*)
>  		*(.got.plt) *(.got)
> -		*(.gnu.linkonce.d.*)
> -		*(.bss*)
> -		*(.dynbss*)
> -		*(.gnu.linkonce.b.*)
> +		*(.bss* .gnu.linkonce.b.*)
>  	}
>  
>  	.altinstructions : {
> @@ -71,7 +68,7 @@ SECTIONS
>  	. = ALIGN(0x100);
>  
>  	.text : {
> -		*(.text*)
> +		*(.text* .gnu.linkonce.t.*)
>  	} :text	=0x90909090
>  }
>  

