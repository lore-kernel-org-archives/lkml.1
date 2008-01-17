Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYAQBab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYAQBab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYAQBaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:30:23 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:53443 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYAQBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:30:22 -0500
Date: Wed, 16 Jan 2008 20:29:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frank Rowand <frank.rowand@am.sony.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 1/4] RT: remove duplicate time/Kconfig
In-Reply-To: <1200530798.3939.17.camel@bx740>
Message-ID: <Pine.LNX.4.58.0801162027110.19540@gandalf.stny.rr.com>
References: <1200435525.4092.14.camel@bx740>  <20080116004051.GF30532@goodmis.org>
 <1200530798.3939.17.camel@bx740>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Frank Rowand wrote:

>
> time/Kconfig added by preempt-realtime-mips.patch duplicates other entry,
> resulting in kernel make error:
>
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> ---
>  arch/mips/Kconfig |    2 	0 +	2 -	0 !
>  1 files changed, 2 deletions(-)
>
> Index: linux-2.6.24-rc7/arch/mips/Kconfig
> ===================================================================
> --- linux-2.6.24-rc7.orig/arch/mips/Kconfig
> +++ linux-2.6.24-rc7/arch/mips/Kconfig
> @@ -1001,8 +1001,6 @@ config BOOT_ELF64
>
>  menu "CPU selection"
>
> -source "kernel/time/Kconfig"
> -
>  choice
>  	prompt "CPU type"
>  	default CPU_R4X00

heh, This doesn't apply either. Or is this to be done before the patches
are added?

Anyway, I did find the two konfig references:

...

          This is purely to save memory - each supported CPU adds
          approximately eight kilobytes to the kernel image.  For best
          performance should round up your number of processors to the next
          power of two.

source "kernel/time/Kconfig"

#
# Timer Interrupt Frequency Configuration
#

...

config GENERIC_TIME
        bool
        default y

source "kernel/time/Kconfig"

config CPU_SPEED
        int "CPU speed used for clocksource/clockevent calculations"
        default 600
endmenu

...


I'll apply your patch in quilt and then make the proper change. Which
Kconfig do you want gone?

-- Steve

