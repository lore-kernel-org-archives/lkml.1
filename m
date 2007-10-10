Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXJIX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXJIX6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXJIX6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:58:13 -0400
Received: from lixom.net ([66.141.50.11]:45160 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXJIX6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:58:12 -0400
Date: Tue, 9 Oct 2007 19:03:18 -0500
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, linuxppc-dev@ozlabs.org
Subject: Re: [stable] [patch 09/12] Fix SMP poweroff hangs
Message-ID: <20071010000318.GA7875@lixom.net>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com> <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com> <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain> <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 04:27:06PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 10 Oct 2007, Thomas Gleixner wrote:
> > 
> > Wrapping it into a #ifdef CONFIG_X86 would be sufficient.
> 
> Well, the ppc oops seems to be a ppc bug regardless.
> 
> If CPU_HOTPLUG isn't defined, the thing does nothing. And if it is 
> defined, I don't see why/how ppc can validly oops. So I think the first 
> thing to do is to try to figure out why it oopses, not to disable it for 
> ppc.

The machine Paul tried on most likely has MPIC interrupt controller, and
the oops was when the pseries_cpu_disable tried calling XICS code instead.
It's not surprising that it failed, I don't think IBM has (traditionally)
cared about cpu hotplug on those machines.

So the PPC-side fix is to not enable cpu hotplug on mpic-based
systems. I'll follow up with a patch, but I have no way to test it since
I only have one POWER5 machine, no other IBM hardware. I'd appreciate
it if someone with hardware could verify it.


-Olof
