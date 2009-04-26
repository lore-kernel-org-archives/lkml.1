Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZDZLNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZDZLNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZDZLM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:12:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52121 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDZLM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:12:58 -0400
Date: Sun, 26 Apr 2009 13:15:02 +0200
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
       Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 03/15] alpha: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426111502.GB28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-3-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:10:58PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Richard Henderson <rth@twiddle.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/alpha/kernel/head.S        |    3 ++-
>  arch/alpha/kernel/vmlinux.lds.S |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/alpha/kernel/head.S b/arch/alpha/kernel/head.S
> index 7ac1f13..4bdd1d2 100644
> --- a/arch/alpha/kernel/head.S
> +++ b/arch/alpha/kernel/head.S
> @@ -7,10 +7,11 @@
>   * the kernel global pointer and jump to the kernel entry-point.
>   */
>  
> +#include <linux/init.h>
>  #include <asm/system.h>
>  #include <asm/asm-offsets.h>
>  
> -.section .text.head, "ax"
> +__HEAD
>  .globl swapper_pg_dir
>  .globl _stext
>  swapper_pg_dir=SWAPPER_PGD
> diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
> index ef37fc1..b9d6568 100644
> --- a/arch/alpha/kernel/vmlinux.lds.S
> +++ b/arch/alpha/kernel/vmlinux.lds.S
> @@ -16,7 +16,7 @@ SECTIONS
>  
>  	_text = .;	/* Text and read-only data */
>  	.text : {
> -	*(.text.head)
> +		HEAD_TEXT
>  		TEXT_TEXT
>  		SCHED_TEXT
>  		LOCK_TEXT
> -- 
> 1.6.2.1
> 
