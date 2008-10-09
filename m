Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbYJITgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbYJITgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYJITfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:35:54 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:57027 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYJITfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:35:53 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 15:35:53 EDT
Date: Thu, 09 Oct 2008 14:35:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: trim ACPI sleep stack buffer
In-reply-to: <20081009180747.GC12507@elf.ucw.cz>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: Matt Mackall <mpm@selenic.com>, "Moore, Robert" <robert.moore@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-id: <alpine.LFD.1.10.0810091435150.3007@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1222819957.13453.15.camel@calx>
 <20081009085649.GC29957@atrey.karlin.mff.cuni.cz>
 <1223571381.17706.94.camel@calx>
 <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain>
 <4911F71203A09E4D9981D27F9D83085803123361@orsmsx503.amr.corp.intel.com>
 <1223574110.17706.109.camel@calx> <20081009180747.GC12507@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied (before the stack change patch:-) to acpi-test

thanks,
-Len

On Thu, 9 Oct 2008, Pavel Machek wrote:

> On Thu 2008-10-09 12:41:50, Matt Mackall wrote:
> > On Thu, 2008-10-09 at 10:23 -0700, Moore, Robert wrote:
> > > Sounds like you need a
> > > 
> > > #define DEFAULT_STACK_SIZE 4096
> > > 
> > > Somewhere.
> > 
> > Or maybe something like this:
> > 
> > 
> > x86: remove magic number from ACPI sleep stack buffer
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> Acked-by: Pavel Machek <pavel@suse.cz>
> 
> > diff -r 375a00b8bf10 arch/x86/kernel/acpi/sleep.c
> > --- a/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:38:55 2008 -0500
> > +++ b/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:40:10 2008 -0500
> > @@ -97,7 +97,7 @@
> >  #else /* CONFIG_64BIT */
> >  	header->trampoline_segment = setup_trampoline() >> 4;
> >  #ifdef CONFIG_SMP
> > -	stack_start.sp = temp_stack + 4096;
> > +	stack_start.sp = temp_stack + sizeof(temp_stack);
> >  #endif
> >  	initial_code = (unsigned long)wakeup_long64;
> >  	saved_magic = 0x123456789abcdef0;
> > 
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
