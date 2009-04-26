Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZDZLU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZDZLU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZDZLUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:20:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38462 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbZDZLUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:20:08 -0400
Date: Sun, 26 Apr 2009 13:22:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 08/15] m68k: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426112217.GG28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-8-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:03PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/m68k/kernel/head.S           |    2 +-
>  arch/m68k/kernel/sun3-head.S      |    2 +-
>  arch/m68k/kernel/vmlinux-std.lds  |    2 +-
>  arch/m68k/kernel/vmlinux-sun3.lds |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
> index f513f53..86edb5f 100644
> --- a/arch/m68k/kernel/head.S
> +++ b/arch/m68k/kernel/head.S
> @@ -577,7 +577,7 @@ func_define	putn,1
>  #endif
>  .endm
>  
> -.section ".text.head","ax"
> +__HEAD
>  ENTRY(_stext)
>  /*
>   * Version numbers of the bootinfo interface
> diff --git a/arch/m68k/kernel/sun3-head.S b/arch/m68k/kernel/sun3-head.S
> index aad0159..9e5c3e5 100644
> --- a/arch/m68k/kernel/sun3-head.S
> +++ b/arch/m68k/kernel/sun3-head.S
> @@ -29,7 +29,7 @@ kernel_pmd_table:              .skip 0x2000
>  .globl kernel_pg_dir
>  .equ    kernel_pg_dir,kernel_pmd_table
>  
> -	.section .text.head
> +	__HEAD
>  ENTRY(_stext)
>  ENTRY(_start)
>  
> diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
> index f846d4e..01d212b 100644
> --- a/arch/m68k/kernel/vmlinux-std.lds
> +++ b/arch/m68k/kernel/vmlinux-std.lds
> @@ -12,7 +12,7 @@ SECTIONS
>    . = 0x1000;
>    _text = .;			/* Text and read-only data */
>    .text : {
> -	*(.text.head)
> +	HEAD_TEXT
>  	TEXT_TEXT
>  	SCHED_TEXT
>  	LOCK_TEXT
> diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
> index d9368c0..c192f77 100644
> --- a/arch/m68k/kernel/vmlinux-sun3.lds
> +++ b/arch/m68k/kernel/vmlinux-sun3.lds
> @@ -12,7 +12,7 @@ SECTIONS
>    . = 0xE002000;
>    _text = .;			/* Text and read-only data */
>    .text : {
> -	*(.text.head)
> +	HEAD_TEXT
>  	TEXT_TEXT
>  	SCHED_TEXT
>  	LOCK_TEXT
> -- 
> 1.6.2.1
> 
