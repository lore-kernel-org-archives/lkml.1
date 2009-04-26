Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZDZLL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZDZLL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZDZLLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:11:49 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35467 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDZLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:11:48 -0400
Date: Sun, 26 Apr 2009 13:13:49 +0200
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
       David Howells <dhowells@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 02/15] xtensa: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426111349.GA28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-2-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:10:57PM -0400, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Chris Zankel <chris@zankel.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/xtensa/kernel/head.S        |    3 ++-
>  arch/xtensa/kernel/vmlinux.lds.S |    4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/head.S b/arch/xtensa/kernel/head.S
> index 0817f9d..d9ddc1b 100644
> --- a/arch/xtensa/kernel/head.S
> +++ b/arch/xtensa/kernel/head.S
> @@ -19,6 +19,7 @@
>  #include <asm/page.h>
>  #include <asm/cacheasm.h>
>  
> +#include <linux/init.h>
>  #include <linux/linkage.h>
>  
>  /*
> @@ -45,7 +46,7 @@
>  	 * instruction.
>  	 */
>  
> -	.section .head.text, "ax"
> +	__HEAD
>  	.globl _start
>  _start:	_j	2f
>  	.align	4
> diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
> index c1be9a4..5accf51 100644
> --- a/arch/xtensa/kernel/vmlinux.lds.S
> +++ b/arch/xtensa/kernel/vmlinux.lds.S
> @@ -85,8 +85,8 @@ SECTIONS
>  
>    .text :
>    {
> -    /* The .head.text section must be the first section! */
> -    *(.head.text)
> +    /* The HEAD_TEXT section must be the first section! */
> +    HEAD_TEXT
>      *(.literal .text)
>      VMLINUX_SYMBOL(__sched_text_start) = .;
>      *(.sched.literal .sched.text)
> -- 
> 1.6.2.1
> 
