Return-Path: <linux-kernel-owner+w=401wt.eu-S965667AbXCGVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbXCGVVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965668AbXCGVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:21:18 -0500
Received: from hermes2.dur.ac.uk ([129.234.8.21]:51937 "EHLO hermes2.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965671AbXCGVVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:21:16 -0500
Date: Wed, 7 Mar 2007 21:25:34 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with
 pci=noacpi
Message-Id: <20070307212534.325f2f32.thatistosayiseenem@gawab.com>
In-Reply-To: <20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
	<20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
	<20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 12:00:04 +0000
Ash Milsted <thatistosayiseenem@gawab.com> wrote:

> On Sun, 4 Mar 2007 14:23:50 +0000
> Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> 
> > On Sat, 3 Mar 2007 15:14:24 +0000
> > Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> > 
> > > Hi,
> > > With 2.6.21-rc2-git1 I have a problem with my ps/2 port keyboard - it only works
> > > with one of the following on the command-line:
> > >  - nolapic
> > >  - irqfixup
> > >  - pci=noacpi
> > > Otherwise it gets stuck with the numlock on.
> > > The following options have no effect:
> > >  - nohz=off (who knows eh?)
> > >  - pci=nomsi
> > > 
> snip
> > > 
> > > Ash
> > 
> > Just checked 2.6.21-rc2-mm1, still has the problem.
> > Also, acpi=noirq fixes it too.
> > To clarify, the problem is that my ps/2 port keyboard is completely frozen
> > on boot - usually it gets activated when udev probes for hardware (my kernel
> > config is highly modular). It worked fine with 2.6.20 and earlier with acpi 
> > taking care of interrupt routing.
> > 
> > Ash
> 
> Any thoughts on this? It still occurs with 2.6.21-rc3. Here's my config
> in case that helps. You'll see that I have swap-prefetch patched in (I
> also have RDSL and some VM changes in there), but I have confirmed that
> the problem occurs with no extra patches. By the way, I tested mm1 with
> a rather different config (I used my distro package) and still saw the
> problem.
> 
> Also, you should probably ignore that bit above where I suggest the
> keyboard driver is being loaded as a module, because of course it
> isn't.. Yet it does start responding (with pci=noacpi) at about that
> time that udev does its thing.
> 
schnip

So, I tracked this down to 2.6.21-git7, the first snapshot that gives me
this problem. Tellingly it does contain an input tree merge. I would git bisect
but I don't have a local copy of the tree - I tried to get one, but it stopped
halfway through the clone, probably because I had to use http... So, I hope that
helps.

Ash

PS: I should have said I'm not subscribed, so please CC me on reply.
PPS: That almost rhymes. Almost.
