Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZDZLWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZDZLWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZDZLWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:22:44 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37444 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZDZLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:22:42 -0400
Date: Sun, 26 Apr 2009 13:24:50 +0200
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
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 13/15] sparc: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426112450.GL28642@uranus.ravnborg.org>
References: <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-13-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:08PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/sparc/kernel/head_32.S     |    2 +-
>  arch/sparc/kernel/vmlinux.lds.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/kernel/head_32.S b/arch/sparc/kernel/head_32.S
> index f0b4b51..e91f01a 100644
> --- a/arch/sparc/kernel/head_32.S
> +++ b/arch/sparc/kernel/head_32.S
> @@ -72,7 +72,7 @@ sun4e_notsup:
>  	.align 4
>  
>  	/* The Sparc trap table, bootloader gives us control at _start. */
> -	.section .text.head,"ax"
> +	__HEAD
>  	.globl	start, _stext, _start, __stext
>  	.globl  trapbase
>  _start:   /* danger danger */
> diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
> index 7626708..fcbbd00 100644
> --- a/arch/sparc/kernel/vmlinux.lds.S
> +++ b/arch/sparc/kernel/vmlinux.lds.S
> @@ -41,7 +41,7 @@ SECTIONS
>  	.text TEXTSTART :
>  	{
>  		_text = .;
> -		*(.text.head)
> +		HEAD_TEXT
>  		TEXT_TEXT
>  		SCHED_TEXT
>  		LOCK_TEXT
> -- 
> 1.6.2.1
> 
