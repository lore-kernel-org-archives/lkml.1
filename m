Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbXBKWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbXBKWrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXBKWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:47:12 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:33366 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbXBKWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:08 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Willy Tarreau <w@1wt.eu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
In-Reply-To: <20070211064636.GA12171@1wt.eu>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>
	 <20070211064636.GA12171@1wt.eu>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 09:47:07 +1100
Message-Id: <1171234027.4493.88.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 07:46 +0100, Willy Tarreau wrote:
> Hi Nigel,
> 
> On Sun, Feb 11, 2007 at 09:37:06AM +1100, Nigel Cunningham wrote:
> > On Sat, 2007-02-10 at 23:20 +0100, Rafael J. Wysocki wrote:
> (...)
> > > What about this:
> > > 
> > > "If the device requires that, implement .suspend and .resume or at least
> > > define .suspend that will always return -ENOSYS (then people will know they
> > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > whether or not the device requires .suspend and .resume, define .suspend that
> > > will always return -ENOSYS."
> > 
> > If your device requires power management, and you know it requires power
> > management, why not just implement power management? Doing -ENOSYS
> > instead is like saying -ESPAMMEBECAUSEIMLAZY.
> 
> No, it means "Not implemented because I don't want to screw that driver with
> something I'm not expert in". And it also means "Other people will quickly
> notice it and will know how to fix this if they really need it".

Ok, that was a bit rough. Sorry.

At the same time though, we were talking about new drivers. If you know
enough to implement the rest of the driver, surely you know enough to
implement the power management part too. (See my previous comment about
the similarities to module load/unload code).

> > Let me put it another way: People keep talking about Linux being ready
> > for the desktop. To me at least (but I dare say for lots of other people
> > too), being ready for the desktop means that things just work, without
> > having to recompile kernels or bug driver authors or wait twelve
> > months. 
> 
> It's *one* usage of Linux. For this usage, you could also suggest to stop
> supporting UP kernels and always build everything with SMP enabled since
> more and more often, people will use multi-core systems. It will exempt
> the users from upgrading their kernels when they replace their CPU. We
> could also try to chase down all the drivers which do not correctly behave
> when the CPU switches to a lower frequency.
> 
> > And it means that doing a bare minimum isn't enough. We keep claiming
> > that Open Source is better than Proprietary software. If we accept
> > half-pie jobs of implementing support for anything - driver power
> > management support or hibernation support or whatever - as 'good
> > enough', we're undercutting that argument. Linux's power management
> > support should - as far as we're able - be at least as good as that
> > other operating system's and preferably way, way better.
> > 
> > -ENOSYS is just not acceptable.
> 
> Nigel, don't take it as a personal offense, but I think it is a very
> centric view of Linux usages. Where I work, Linux is used a lot on
> servers and appliances. It is used for mail relays, HTTP proxies,
> anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
> etc... Nobody would ever want to enable power management on those
> machines, let alone suspend which would cause a major havoc, would
> the system decide to enter suspend for any reason.

I agree.

> Many people also have Linux on their notebooks, but as a dual-boot. You
> read the word ? "dual-boot". It means that they cleanly shutdown their
> system every time they don't use it anymore, and they won't know what
> OS they'll use next time.

Not necessarily. I dual boot our desktop machine, and hibernate both,
using grub to select with OS to run.

> I've never heard anyone there complaining "oh, I'm fed up with this
> boring boot, I always have to wait 30 seconds when I need to do
> something, I wish I could suspend and resume". It is considered the
> normal way of using their PCs.
> 
> So globally, those hundreds of notebooks, workstations and servers
> will not be customers of the suspend code any time soon. It would
> be a shame to deprive them from working drivers. You must just
> accept that a lot of people are not interested in your work. It's
> the same for all of us here. I know that a lot of people are not
> interested in 2.4 anymore and I'm perfectly fine with that. I'm
> not asking 2.6 driver authors to ensure that their driver is easy
> to backport for instance.

Neither am I. I'm just asking that new drivers have power management as
standard.

> What I really think would be a clean solution would be sort of
> a capability. Either the driver *is* suspend/resume-capable, and
> the system can be suspended. Or it is not, and the system must
> refuse to suspend. It should not be a problem to proceed like
> this because drivers which will not support suspend will mainly
> be those which will not have to. And if a user occasionnaly
> complains that one driver does not support it, at least you will
> have a good argument against its author to implement suspend.

Yes, but why should the user have to complain to start with?

Regards,

Nigel

