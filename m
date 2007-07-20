Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbXGTIHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbXGTIHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762221AbXGTIG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:06:56 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:42924 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbXGTIGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:06:52 -0400
Date: Fri, 20 Jul 2007 10:06:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] m68k: use .text.head
Message-ID: <20070720080623.GB15534@osiris.boeblingen.de.ibm.com>
References: <E1IBjEq-0004ks-5L@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IBjEq-0004ks-5L@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 04:33:08AM +0100, Al Viro wrote:
> 
> i.e. tell modpost that entry point code (that has to be outside
> of .init.text for external reasons) is OK to refer to .init.*
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/arch/m68k/kernel/sun3-head.S b/arch/m68k/kernel/sun3-head.S
> index 4b5f050..aad0159 100644
> --- a/arch/m68k/kernel/sun3-head.S
> +++ b/arch/m68k/kernel/sun3-head.S
> @@ -29,7 +29,7 @@ kernel_pmd_table:              .skip 0x2000
>  .globl kernel_pg_dir
>  .equ    kernel_pg_dir,kernel_pmd_table
> 
> -	.section .head
> +	.section .text.head
>  ENTRY(_stext)
>  ENTRY(_start)
> 
> diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
> index f06425b..4adffef 100644
> --- a/arch/m68k/kernel/vmlinux-sun3.lds
> +++ b/arch/m68k/kernel/vmlinux-sun3.lds
> @@ -11,7 +11,7 @@ SECTIONS
>    . = 0xE002000;
>    _text = .;			/* Text and read-only data */
>    .text : {
> -	*(.head)
> +	*(.text.head)
>  	TEXT_TEXT
>  	SCHED_TEXT
>  	LOCK_TEXT

I was wondering how to "fix" this on s390 since we have the same issue.
So I'll do it the same way here. Thanks.
