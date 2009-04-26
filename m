Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZDZLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZDZLUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZDZLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:20:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38580 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbZDZLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:20:33 -0400
Date: Sun, 26 Apr 2009 13:22:42 +0200
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
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/15] mn10300: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426112242.GH28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-9-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:04PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David Howells <dhowells@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/mn10300/kernel/head.S        |    3 ++-
>  arch/mn10300/kernel/vmlinux.lds.S |    5 +----
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/mn10300/kernel/head.S b/arch/mn10300/kernel/head.S
> index 8a8309f..14f27f3 100644
> --- a/arch/mn10300/kernel/head.S
> +++ b/arch/mn10300/kernel/head.S
> @@ -9,6 +9,7 @@
>   * 2 of the Licence, or (at your option) any later version.
>   */
>  
> +#include <linux/init.h>
>  #include <linux/threads.h>
>  #include <linux/linkage.h>
>  #include <linux/serial_reg.h>
> @@ -19,7 +20,7 @@
>  #include <asm/param.h>
>  #include <unit/serial.h>
>  
> -	.section .text.head,"ax"
> +	__HEAD
>  
>  ###############################################################################
>  #
> diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
> index b825966..24de6b9 100644
> --- a/arch/mn10300/kernel/vmlinux.lds.S
> +++ b/arch/mn10300/kernel/vmlinux.lds.S
> @@ -27,10 +27,7 @@ SECTIONS
>    _stext = .;
>    _text = .;			/* Text and read-only data */
>    .text : {
> -	*(
> -	.text.head
> -	.text
> -	)
> +	HEAD_TEXT
>  	TEXT_TEXT
>  	SCHED_TEXT
>  	LOCK_TEXT
> -- 
> 1.6.2.1
> 
