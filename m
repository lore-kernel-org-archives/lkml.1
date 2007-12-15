Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXLOBHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXLOBHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLOBGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:06:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbXLOBGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:06:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sat, 15 Dec 2007 02:25:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bcm43xx-dev@lists.berlios.de, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       stefano.brivio@polimi.it, Ray Lee <ray-lk@madrabbit.org>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, kjwinchester@gmail.com,
       Linus Torvalds <torvalds@linux-foundation.org>, mbuesch@freenet.de
References: <20071213003028.676998182@mvista.com> <20071214175910.GA27078@elte.hu> <200712141938.10733.mb@bu3sch.de>
In-Reply-To: <200712141938.10733.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150225.52183.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of December 2007, Michael Buesch wrote:
> On Friday 14 December 2007 18:59:10 Ingo Molnar wrote:
> > 
> > * Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > In my opinion this all is the work of the distributions and not the 
> > > work of the kernel developers. Distributions have to make sure that 
> > > everything works after a kernel update. [...]
> > 
> > actually, not. The the task of kernel developers is to KEEP OLD 
> > DISTRIBUTIONS WORKING WITH NEW DRIVERS. Or the "old" driver stays around 
> > until eternity, because the new one is just BROKEN.
> 
> What exactly prevents an old distribution from using new b43
> given that they fix their broken udev scripts first?
> 
> (I cannot fix their broken scripts from within the kernel.)

Well, we talked about that some time ago, didn't we?

The rule is this: if one uses kernel 2.6.x from kernel.org _successfully_
with certain distribution (whatever it is), then one is supposed to be able to
take the kernel 2.6.(x+1), install it on that distribution and use it without
any major configuration changes.  If this rule is not followed, people will
stop testing kernel.org kernels and we'll all suffer from that.

Now, in my not so humble opinion, switching from bcm43xx to b43 _is_ a major
configuration change (I did it, so please don't try to discuss with my
experience) and forcing users to do that breaks the rule above.

> > Take a look at CONFIG_COMPAT_VDSO for example - one single version of 
> > glibc was released in a distro that depended on a kernel vDSO bug. So 
> > we'll keep that aspect of the vDSO perhaps forever. Simple as that. 
> > Stuff must just work. Whatever it takes. Best is if you add in new stuff 
> > without the user noticing _ANYTHING_ but that the kernel version bumped. 
> > If the maintainers of the other 7 million lines of kernel code can get 
> > this right then the wireless code should be able to do it too. Ok?
> > 
> > all this "distributors will have to sort out the mess" talk is nonsense, 
> > and i really hope you do not truly believe in that crap. If your 
> > attitude is prevalent in the wireless development community then it's in 
> > worse shape than i thought :-(
> 
> Sorry if I didn't chose my wording correctly. But I was only talking
> about the development of drivers. It is correct that userspace ABI has
> to be preserved, but that is not an issue at all to drivers.
> I was talking about things like installing the right firmware for
> the new driver. It is the job of the distributors to install the new
> firmware when they introduce a new driver.

Yes, as far as new distributions are concerned.  However, we _want_ kernel.org
kernels to work with the old ones too.  Yes, WE DO.

> It is the job of the distributors to test their userland scripts and
> configuration stuff with that driver and fix their stuff. It is _not_ my job
> to fix random distribution udev scripts or explaining over and over again to
> people how the firmware is installed.

Given specific software environment (it may be a home-made system compiled
from sources or whatever), if installing a new kernel forces me to reconfigure
it in any significant way to obtain the functionality that I previously had,
the problem is with the kernel.  No less, no more.

> Either distributions have to install it automatically or people simply have
> to read one or two lines of documentation.  That's just what I wanted to say.

It's not that simple.  For example, regression testing will be a major PITA
if one needs to switch back and forth from the new driver to the old one in the
process.

> Of course it is _my_ job to preserve ABI. I did never want to question that.

Greetings,
Rafael
