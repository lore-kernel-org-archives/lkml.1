Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYDHUAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYDHUAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYDHUAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:00:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185AbYDHUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:00:22 -0400
Date: Tue, 8 Apr 2008 21:59:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] e1000e broke e1000 (was: Re: [ANNOUNCE] e1000
	toe1000e migration of PCI Express devices)
Message-ID: <20080408195949.GB28148@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brandeburg, Jesse <jesse.brandeburg@intel.com> wrote:

> your expectation is that e1000 once loaded on this device in a 
> previous kernel (2.6.24) so it should continue to work, right? [...]

correct.

> > the eth0 interface is not detected at all:
> >    http://redhat.com/~mingo/misc/dmesg.e1000.bad
> 
> if you're running a no module kernel, you'll need to set 
> CONFIG_E1000E=y for your device to be detected.

there should be no need for me to set something that the kernel can do 
itself as well ...

> If there is a more reasonable solution you can come up with I am 
> interested.

i think the solution is obvious and simple: if e1000 is built-in then 
e1000e should not be allowed to be a module. (i.e. it should either be 
built-in in which case it will handle the PCI IDs, or it should be 
disabled - in which case e1000 will handle them.)

that way e1000e can take over the PCI IDs but we'll never get a 
non-working system, which takes an hour for a kernel hacker to figure 
out. The failure was totally silent. eth0 didnt show up at all.

Btw., a sidenote: this is another generally annoying property of Linux: 
there's no easy and user-visible enumeration of PCI IDs (devices) that 
we _could_ support but dont enable for some reason. It is a royal PITA 
to track down when some driver decides to (silently) ignore a piece of 
hardware.

Having a seemingly dead piece of hardware component is one of the most 
frustrating user experiences possible - the first instinctive reaction 
is "did my hw break???". The kernel should proactively know about all 
inactive pieces of hardware and should have a one-stop-shop for users 
where they can reassure themselves which devices are not active and why.

	Ingo
