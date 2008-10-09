Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYJIVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYJIVVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYJIVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:21:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYJIVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:21:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: trim ACPI sleep stack buffer
Date: Thu, 9 Oct 2008 23:25:23 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Matt Mackall <mpm@selenic.com>,
       "Moore, Robert" <robert.moore@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <1222819957.13453.15.camel@calx> <20081009180747.GC12507@elf.ucw.cz> <alpine.LFD.1.10.0810091435150.3007@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810091435150.3007@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810092325.24283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 of October 2008, Len Brown wrote:
> applied (before the stack change patch:-) to acpi-test

FWIW, I had a look at it, looks good.

Thanks,
Rafael


> On Thu, 9 Oct 2008, Pavel Machek wrote:
> 
> > On Thu 2008-10-09 12:41:50, Matt Mackall wrote:
> > > On Thu, 2008-10-09 at 10:23 -0700, Moore, Robert wrote:
> > > > Sounds like you need a
> > > > 
> > > > #define DEFAULT_STACK_SIZE 4096
> > > > 
> > > > Somewhere.
> > > 
> > > Or maybe something like this:
> > > 
> > > 
> > > x86: remove magic number from ACPI sleep stack buffer
> > > 
> > > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > Acked-by: Pavel Machek <pavel@suse.cz>
> > 
> > > diff -r 375a00b8bf10 arch/x86/kernel/acpi/sleep.c
> > > --- a/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:38:55 2008 -0500
> > > +++ b/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:40:10 2008 -0500
> > > @@ -97,7 +97,7 @@
> > >  #else /* CONFIG_64BIT */
> > >  	header->trampoline_segment = setup_trampoline() >> 4;
> > >  #ifdef CONFIG_SMP
> > > -	stack_start.sp = temp_stack + 4096;
> > > +	stack_start.sp = temp_stack + sizeof(temp_stack);
> > >  #endif
> > >  	initial_code = (unsigned long)wakeup_long64;
> > >  	saved_magic = 0x123456789abcdef0;
> > > 
> > > 
> > 
> > -- 
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


