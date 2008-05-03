Return-Path: <linux-kernel-owner+w=401wt.eu-S1763683AbYECQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763683AbYECQKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYECQKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:10:07 -0400
Received: from smtp.enter.net ([216.193.128.24]:2565 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYECQKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:10:06 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Strange linux-next build error
Date: Sat, 3 May 2008 12:10:02 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>, linux-next@vger.kernel.org
References: <200805030121.39831.dhazelton@enter.net> <20080503155252.0dc9c4d7.sfr@canb.auug.org.au> <20080503064057.GA12546@uranus.ravnborg.org>
In-Reply-To: <20080503064057.GA12546@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031210.03168.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008 02:40:57 Sam Ravnborg wrote:
> On Sat, May 03, 2008 at 03:52:52PM +1000, Stephen Rothwell wrote:
> > Just adding some cc's ... it is worth cc'ing linux-next for bugs in
> > linux-next (instead, or as well, as me personally) since people who are
> > interested are probably subscribed there.

Ah, yes - I'm not very good at remembering fine details like that :)

> > On Sat, 3 May 2008 01:21:38 -0400 Daniel Hazelton <dhazelton@enter.net> 
wrote:
> > > After updating my local tree to the latest linux-next and starting a
> > > clean build I see this error *ONLY* the first time I start a "make
> > > bzImage"
> > >
> > >   CC      arch/x86/kernel/acpi/sleep.o
> > >   LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
> > > cc1: fatal error: opening output file
> > > arch/x86/kernel/acpi/realmode/wakeup.lds: Permission denied
> > > compilation terminated.
> > > make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.lds] Error 1
> > > make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
> > > make[2]: *** [arch/x86/kernel/acpi] Error 2
> > > make[1]: *** [arch/x86/kernel] Error 2
> > > make: *** [bzImage] Error 2
>
> Hi Daniel.
>
> It looks like we visit arch/x86/kernel/acpi/realmode/Makefile
> twice in parallel as we have both make[4] and make[3] in play here.
> Or maybe we have a dependency bug in the Makefile.
>
> Can you try to do a:
> make V=1 and post the output a few screen fulls before and until
> the bug triggers.
> They I will see if I can work out what is happening.
>
> Thanks,
> 	Sam

Will do. I'll run a "make mrproper" and then rebuild the kernel with V=1

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
