Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXBKGrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXBKGrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXBKGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:47:39 -0500
Received: from 1wt.eu ([62.212.114.60]:2315 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbXBKGri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:47:38 -0500
Date: Sun, 11 Feb 2007 07:46:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211064636.GA12171@1wt.eu>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171147026.19894.16.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nigel,

On Sun, Feb 11, 2007 at 09:37:06AM +1100, Nigel Cunningham wrote:
> On Sat, 2007-02-10 at 23:20 +0100, Rafael J. Wysocki wrote:
(...)
> > What about this:
> > 
> > "If the device requires that, implement .suspend and .resume or at least
> > define .suspend that will always return -ENOSYS (then people will know they
> > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > whether or not the device requires .suspend and .resume, define .suspend that
> > will always return -ENOSYS."
> 
> If your device requires power management, and you know it requires power
> management, why not just implement power management? Doing -ENOSYS
> instead is like saying -ESPAMMEBECAUSEIMLAZY.

No, it means "Not implemented because I don't want to screw that driver with
something I'm not expert in". And it also means "Other people will quickly
notice it and will know how to fix this if they really need it".

> Let me put it another way: People keep talking about Linux being ready
> for the desktop. To me at least (but I dare say for lots of other people
> too), being ready for the desktop means that things just work, without
> having to recompile kernels or bug driver authors or wait twelve
> months. 

It's *one* usage of Linux. For this usage, you could also suggest to stop
supporting UP kernels and always build everything with SMP enabled since
more and more often, people will use multi-core systems. It will exempt
the users from upgrading their kernels when they replace their CPU. We
could also try to chase down all the drivers which do not correctly behave
when the CPU switches to a lower frequency.

> And it means that doing a bare minimum isn't enough. We keep claiming
> that Open Source is better than Proprietary software. If we accept
> half-pie jobs of implementing support for anything - driver power
> management support or hibernation support or whatever - as 'good
> enough', we're undercutting that argument. Linux's power management
> support should - as far as we're able - be at least as good as that
> other operating system's and preferably way, way better.
> 
> -ENOSYS is just not acceptable.

Nigel, don't take it as a personal offense, but I think it is a very
centric view of Linux usages. Where I work, Linux is used a lot on
servers and appliances. It is used for mail relays, HTTP proxies,
anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
etc... Nobody would ever want to enable power management on those
machines, let alone suspend which would cause a major havoc, would
the system decide to enter suspend for any reason.

Many people also have Linux on their notebooks, but as a dual-boot. You
read the word ? "dual-boot". It means that they cleanly shutdown their
system every time they don't use it anymore, and they won't know what
OS they'll use next time.

I've never heard anyone there complaining "oh, I'm fed up with this
boring boot, I always have to wait 30 seconds when I need to do
something, I wish I could suspend and resume". It is considered the
normal way of using their PCs.

So globally, those hundreds of notebooks, workstations and servers
will not be customers of the suspend code any time soon. It would
be a shame to deprive them from working drivers. You must just
accept that a lot of people are not interested in your work. It's
the same for all of us here. I know that a lot of people are not
interested in 2.4 anymore and I'm perfectly fine with that. I'm
not asking 2.6 driver authors to ensure that their driver is easy
to backport for instance.

What I really think would be a clean solution would be sort of
a capability. Either the driver *is* suspend/resume-capable, and
the system can be suspended. Or it is not, and the system must
refuse to suspend. It should not be a problem to proceed like
this because drivers which will not support suspend will mainly
be those which will not have to. And if a user occasionnaly
complains that one driver does not support it, at least you will
have a good argument against its author to implement suspend.

Best regards,
Willy

