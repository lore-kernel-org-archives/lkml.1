Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZDZLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZDZLT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZDZLTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:19:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43726 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZDZLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:19:16 -0400
Date: Sun, 26 Apr 2009 13:21:24 +0200
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
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 06/15] ia64: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426112124.GE28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-6-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:01PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Tony Luck <tony.luck@intel.com>
> ---
>  arch/ia64/kernel/head.S        |    2 +-
>  arch/ia64/kernel/vmlinux.lds.S |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
> index 23f846d..a572160 100644
> --- a/arch/ia64/kernel/head.S
> +++ b/arch/ia64/kernel/head.S
> @@ -181,7 +181,7 @@ swapper_pg_dir:
>  halt_msg:
>  	stringz "Halting kernel\n"
>  
> -	.section .text.head,"ax"
> +	__HEAD
>  
>  	.global start_ap
>  
> diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
> index 4a95e86..a8b879e 100644
> --- a/arch/ia64/kernel/vmlinux.lds.S
> +++ b/arch/ia64/kernel/vmlinux.lds.S
> @@ -51,8 +51,8 @@ SECTIONS
>  	KPROBES_TEXT
>  	*(.gnu.linkonce.t*)
>      }
> -  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
> -	{ *(.text.head) }
> +  HEAD_TEXT_SECTION : AT(ADDR(HEAD_TEXT_SECTION) - LOAD_OFFSET)
> +	{ HEAD_TEXT }

1) Spell it out directly rahter than using a macro
2) Consider fixing the style when you are here anyway.
   The 'correct' style is to use C rules for '{}' and indent.
   But I guess you followed style of the file - which is ok.

	Sam
