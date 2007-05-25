Return-Path: <linux-kernel-owner+w=401wt.eu-S1764085AbXEYRV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764085AbXEYRV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762158AbXEYRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:21:51 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbXEYRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:21:49 -0400
Date: Fri, 25 May 2007 10:19:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Chris Newport <crn@netunix.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <20070525180304.2cc4dae0@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0705251012200.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
 <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
 <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com>
 <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
 <20070525180304.2cc4dae0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Alan Cox wrote:
> 
> There is an additional factor - dumps contain data which variously is -
> copyright third parties, protected by privacy laws, just personally
> private, security sensitive (eg browser history) and so on.

Yes. 

I'm sure we've had one or two crashdumps over the years that have actually 
clarified a bug.

But I seriously doubt it is more than a handful. 

> Diskdump (and even more so netdump) are useful in the hands of a
> developer crashing their own box just like kgdb, but not in the the
> normal and rational end user response of  "its broken, hit reset"

Amen, brother.

Even for developers, I suspect a _lot_ of people end up doing "ok, let's 
bisect this" or some other method to narrow it down to a specific case, 
and then staring at the source code once they get to that point.

At least I hope so. Even in user space, you should generally use gdb to 
get a traceback and perhaps variable information, and then go look at the 
source code.

Yes, dumps can (in theory) be useful for one-off issues, but I doubt many 
people have ever been able to get anything much more out of them than from 
a kernel "oops" message. 

For developers, I can heartily recommend the firewire-based remote debug 
facilities that the PowerPC people use. I've used it once or twice, and it 
is fairly simple and much better than a full dump (adn it works even when 
the CPU is totally locked up, which is the best reason for using it).

But 99% of the time, the problem doesn't happen on a developer machine, 
and even if it does, 90% of the time you really just want the traceback 
and register info that you get out of an oops.

			Linus
