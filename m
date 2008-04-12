Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYDLQ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYDLQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYDLQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:56:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33311 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbYDLQ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:56:16 -0400
Date: Sat, 12 Apr 2008 18:56:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: setup_trampoline() - fix section mismatch warning
Message-ID: <20080412165645.GA6717@uranus.ravnborg.org>
References: <47FE6799.9030606@gmail.com> <20080411175006.GA31716@uranus.ravnborg.org> <48009650.5090306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48009650.5090306@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 01:00:32PM +0200, Jacek Luczak wrote:
> 
> Hi Sam,
> 
> Sam Ravnborg pisze:
> [!snip]
> >> diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
> >> index 4aedd0b..2a07e67 100644
> >> --- a/arch/x86/kernel/trampoline_64.S
> >> +++ b/arch/x86/kernel/trampoline_64.S
> >> @@ -32,7 +32,7 @@
> >>  
> >>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
> >>  #ifndef CONFIG_HOTPLUG_CPU
> >> -.section .init.data, "aw", @progbits
> >> +.section .cpuinit.data, "aw", @progbits
> >>  #else
> >>  .section .rodata, "a", @progbits
> >>  #endif
> > 
> > The correct fix would be to drop the
> > preprocessor directves and use __CPUINITDATA
> 
> Hmm...IMO this should stay in that form at least now.
> I will make some tests with __CPUINITDATA (look into objects, etc.) and later on we can
> switch. Is it OK for you?

I should maybe give you a little more background.
The __cpuinitdata section is properly discarded after init
has completed in case CPUHOTPLUG is not needed.
But in case it is needed then the section is kept.

So the only issue with introducing the patch as I suggest
is that we loose the readonly. We need to introduce
__CPUINITCONST to cover that case.
But loosing readonly is not a big deal here.

If you insist on the readonly part then unconditionally
use the section named .cpuinit.rodata
But the preprocessor directive should in any case be dropped
as it is of no real use today.

	Sam
