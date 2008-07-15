Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYGOUAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYGOUAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGOUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:00:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47005 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYGOUAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:00:05 -0400
Message-ID: <487D01B5.7020300@garzik.org>
Date: Tue, 15 Jul 2008 15:59:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org> <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> Because people should not be forced to fix all their firmware-related breakage
>> immediately, just to boot 2.6.27.
> 
> You're continuing to make an argument that doesn't seem to backed up with 
> any actual real problems.
> 
> Can you point to real breakage? For real people? 

Already posted a list.


> It sounds like your whole argument literally boils down to "one or two 
> people doing something really stupid or odd cannot just fix their setup".
> 
> What is the real-life situation where copying the firmware with the 
> modules (but still as separate files) actually breaks?

The breakage comes from all the existing-at-this-point-today processes 
that will not copy the firmware with the module.

We're not talking about one or two people, we are talking about projects 
being actively used.

Which in turn means not only those projects need to immediately fix 
stuff to make 2.6.27 work, but users who build and test kernels are left 
to pick up the pieces when their drivers break too.


> IOW, what _is_ this theoretical breakage? And why is it so deadly 
> suddenly? Give us real examples that somehow cannot be fixed?

It's not theoretical, we have already run into non-working drivers due 
to build process changes.  And those were the smart guys, the kernel 
hackers.

All of the examples I have listed can certainly be fixed -- well, except 
the "new kernel, old system" case -- sometimes easily.

* the consequences of the breakage -- 100% non-working driver, possibly 
unbootable system

* the likelihood of breakage -- anything that is not a recent version of 
a mainstream distro WILL have problems, because it simply does not know 
about the firmware that must follow the module whereever it goes.

* the need to immediately add/fix userland and build processes, just to 
keep the same driver set working.

* the need for time, to figure out if you are even affected by this change

* the need for time, to plan the best method to implement firmware 
deployment in your distro


Without firmware-in-module, it is a basic fact that you are forcing 
everyone to fix their stuff, simply to be able to use 2.6.27 like they 
did 2.6.26.

That's unfriendly to distros, users, and kernel testers.

	Jeff



