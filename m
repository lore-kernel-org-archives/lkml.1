Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZDZLR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZDZLR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZDZLRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:17:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43325 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDZLRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:17:15 -0400
Date: Sun, 26 Apr 2009 13:19:24 +0200
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
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426111924.GD28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-5-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:00PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/kernel/head-nommu.S  |    2 +-
>  arch/arm/kernel/head.S        |    2 +-
>  arch/arm/kernel/vmlinux.lds.S |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
> index cc87e17..4f10d1c 100644
> --- a/arch/arm/kernel/head-nommu.S
> +++ b/arch/arm/kernel/head-nommu.S
> @@ -32,7 +32,7 @@
>   * numbers for r1.
>   *
>   */
> -	.section ".text.head", "ax"
> +	__HEAD
>  ENTRY(stext)
>  	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
>  						@ and irqs disabled
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 21e17dc..f1877a5 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -74,7 +74,7 @@
>   * crap here - that's what the boot loader (or in extreme, well justified
>   * circumstances, zImage) is for.
>   */
> -	.section ".text.head", "ax"
> +	__HEAD
>  ENTRY(stext)
>  	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
>  						@ and irqs disabled
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index c90f272..655fb75 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -23,10 +23,10 @@ SECTIONS
>  #else
>  	. = PAGE_OFFSET + TEXT_OFFSET;
>  #endif
> -	.text.head : {
> +	HEAD_TEXT_SECTION : {

Spell it out direct rather than hiding the .head.text
behind a macro name here.

	Sam
