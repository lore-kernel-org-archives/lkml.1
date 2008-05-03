Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYECGkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYECGkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYECGkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:40:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41330 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbYECGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:40:23 -0400
Date: Sat, 3 May 2008 08:40:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Hazelton <dhazelton@enter.net>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       linux-next@vger.kernel.org
Subject: Re: Strange linux-next build error
Message-ID: <20080503064057.GA12546@uranus.ravnborg.org>
References: <200805030121.39831.dhazelton@enter.net> <20080503155252.0dc9c4d7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503155252.0dc9c4d7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 03:52:52PM +1000, Stephen Rothwell wrote:
> Just adding some cc's ... it is worth cc'ing linux-next for bugs in
> linux-next (instead, or as well, as me personally) since people who are
> interested are probably subscribed there.
> 
> On Sat, 3 May 2008 01:21:38 -0400 Daniel Hazelton <dhazelton@enter.net> wrote:
> >
> > After updating my local tree to the latest linux-next and starting a clean 
> > build I see this error *ONLY* the first time I start a "make bzImage"
> > 
> >   CC      arch/x86/kernel/acpi/sleep.o
> >   LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
> > cc1: fatal error: opening output file 
> > arch/x86/kernel/acpi/realmode/wakeup.lds: Permission denied
> > compilation terminated.
> > make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.lds] Error 1
> > make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
> > make[2]: *** [arch/x86/kernel/acpi] Error 2
> > make[1]: *** [arch/x86/kernel] Error 2
> > make: *** [bzImage] Error 2

Hi Daniel.

It looks like we visit arch/x86/kernel/acpi/realmode/Makefile
twice in parallel as we have both make[4] and make[3] in play here.
Or maybe we have a dependency bug in the Makefile.

Can you try to do a:
make V=1 and post the output a few screen fulls before and until
the bug triggers.
They I will see if I can work out what is happening.

Thanks,
	Sam
