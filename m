Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYJIRTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYJIRTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYJIRTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:19:36 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:46253 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYJIRTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:19:35 -0400
Date: Thu, 09 Oct 2008 13:19:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: trim ACPI sleep stack buffer
In-reply-to: <1223571381.17706.94.camel@calx>
X-X-Sender: lenb@localhost.localdomain
To: Matt Mackall <mpm@selenic.com>
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1222819957.13453.15.camel@calx>
 <20081009085649.GC29957@atrey.karlin.mff.cuni.cz>
 <1223571381.17706.94.camel@calx>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test.

thanks Matt,
-Len

On Thu, 9 Oct 2008, Matt Mackall wrote:

> On Thu, 2008-10-09 at 10:56 +0200, Pavel Machek wrote:
> > > We've got:
> > > 
> > > #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
> > > static char temp_stack[10240];
> > > #endif
> > > 
> > > and:
> > > 
> > > #ifdef CONFIG_SMP
> > >         stack_start.sp = temp_stack + 4096;
> > > #endif
> > > 
> > > ..which suggests we use at most 4k of the stack?
> > 
> > I guess someone (probably me) was "playing it safe" -- not exactly
> > remembering if stack grows down or up. I guess it should be safe to
> > change it... will do that.
> > 									Pavel
> 
> I've already got a patch, I was just wondering if there was some obscure
> architectural reason for it that I wasn't aware of.
> 
> 
> x86: trim ACPI sleep stack buffer
> 
> x86_64 SMP suspend to RAM uses a 10k temporary stack for saving the
> kernel state, but only 4k of it is used. Shrink it to 4k.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r 73d55a1b6c10 arch/x86/kernel/acpi/sleep.c
> --- a/arch/x86/kernel/acpi/sleep.c	Wed Oct 08 14:48:45 2008 -0500
> +++ b/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 11:51:54 2008 -0500
> @@ -21,7 +21,7 @@
>  static unsigned long acpi_realmode;
>  
>  #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
> -static char temp_stack[10240];
> +static char temp_stack[4096];
>  #endif
>  
>  /**
> 
> -- 
> Mathematics is the supreme nostalgia of our time.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
