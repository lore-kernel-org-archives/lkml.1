Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbYENVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbYENVeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYENVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:34:06 -0400
Received: from keil-draco.com ([216.193.185.50]:44443 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYENVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:34:04 -0400
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 17:34:04 EDT
From: me <dhazelton@enter.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1
Date: Wed, 14 May 2008 17:14:41 -0400
User-Agent: KMail/1.9.9
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <1210798147.4234.5.camel@localhost> <20080514140032.83fc25b7.akpm@linux-foundation.org>
In-Reply-To: <20080514140032.83fc25b7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805141714.42129.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2008 05:00:32 pm Andrew Morton wrote:
> On Wed, 14 May 2008 14:49:07 -0600
>
> Zan Lynx <zlynx@acm.org> wrote:
> > On Wed, 2008-05-14 at 01:01 -0700, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc
> > >2/2.6.26-rc2-mm1/
> > >
> > >
> > > - The -mm tree is now based on linux-next.
> > >
> > >   I will occasionally pick up later versions of trees which are already
> > >   in linux-next, to catch material which was added after Stephen last
> > >   pulled that tree.  That happened this time: git-net had a lot of
> > > driver changes which weren't in linux-next and which I wanted in
> > >   2.6.26-rc2-mm1.
> > >
> > > - A few more git trees were added: git-ubifs.patch,
> > > git-regulator.patch, git-logfs.patch, git-orion.patch.
> >
> > No good on my first attempt.  Here is what I ran into:
> >
> > The printk timestamps have gone wild.  I cannot paste a dmesg but here
> > is one line I wrote down:
> > [17180644.495790] Testing tracer ftrace: NMI watchdog ...
>
> I've seen reports like this against mainline, but I'm not sure that
> much has been done about it yet.

I've reported problems with -next and ftrace. The timestamps look very similar 
to what I've seen as well. I don't have those kernels available anymore - I 
decided to wipe my system and move to a distro where it's easier to test new 
kernels.

However, it stands to reason that it isn't ftrace actually causing the 
problem.

> > Which leads into the next problem: The kernel freezes after Testing
> > tracer ftrace.  Then I rebooted with my special testing command line
> > "kernel /bzImage-2.6.26-rc2-mm1 root=/dev/sda2 rootfstype=reiser4
> > rootflags=defaults,noatime i8042.nomux elevator=cfq resume=/dev/sda3
> > panic=5 nmi_watchdog=2,panic debug idle=poll nohz=off"
> >
> > and I got the same freeze but then the NMI watchdog message.  Which is
> > the third problem.
> >
> > Why did the NMI watchdog not panic and reboot the system?  It detected
> > the lock and printed the message.  It should have then panicked, waited
> > 5 seconds, and rebooted.
> >
> > System is a 64-bit Gentoo AMD-64 Compaq R3000 laptop.  Compiler is GCC
> > 4.3.

That is quite similar... I'm on a Core2Duo (Dell Inspiron 1420 laptop) and was 
seeing the problems with GCC4.3 and a pure 64bit userland.

DRH

> afaict this is all Ingo/Thomas stuff, so I'll add the ccs and run away :(
>
> > Config follows:
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
