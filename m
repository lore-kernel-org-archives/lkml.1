Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYDHUSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYDHUSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYDHUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:18:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46232 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYDHUSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:18:09 -0400
Date: Tue, 8 Apr 2008 22:17:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
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
Message-ID: <20080408201723.GD28148@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com> <20080408195949.GB28148@elte.hu> <20080408200417.GI11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408200417.GI11962@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Apr 08, 2008 at 09:59:49PM +0200, Ingo Molnar wrote:
> > Btw., a sidenote: this is another generally annoying property of Linux: 
> > there's no easy and user-visible enumeration of PCI IDs (devices) that 
> > we _could_ support but dont enable for some reason. It is a royal PITA 
> > to track down when some driver decides to (silently) ignore a piece of 
> > hardware.
> > 
> > Having a seemingly dead piece of hardware component is one of the most 
> > frustrating user experiences possible - the first instinctive reaction 
> > is "did my hw break???". The kernel should proactively know about all 
> > inactive pieces of hardware and should have a one-stop-shop for users 
> > where they can reassure themselves which devices are not active and why.
> 
> It's almost trivial to add new string attributes to sysfs.  We could 
> have a file, say, /sys/bus/pci/devices/0000:07:03.0/broken which lspci 
> could read to see if anything's left a message for us.
> 
> Is that the kind of thing you had in mind?

yep, that would be fantastic.

i guess more could be done as well - this was just the result of 10 
seconds of thinking - please try to think all such scenarios through 
with the mindset of the user who is faced with a non-working device. Our 
failure diagnostics are rather ad-hoc in general. Say an USB stick did 
not come up. Or some card isnt working. Or the mouse is dead. Plain 
everyday annoyances - we need good, unified, understandable interfaces 
for users to get reassurances and vectors of action from. Maybe even a 
WARN_ON() for kerneloops.org to pick up automatically. _Anything_ that 
is actionable by plain users. Because failures in hw functionality is 
one of the most serious failure an OS can impose on users (it's only 
slightly better than say data loss, and clearly worse to most users than 
say sporadic crashes), and it is the main area where we _lose_ users 
every day.

	Ingo
