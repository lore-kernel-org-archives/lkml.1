Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYDHTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYDHTwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYDHTwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:52:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYDHTwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:52:11 -0400
Date: Tue, 8 Apr 2008 21:51:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] e1000e broke e1000 (was: Re: [ANNOUNCE] e1000 to
	e1000e migration of PCI Express devices)
Message-ID: <20080408195123.GA28148@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408193245.GG11962@parisc-linux.org>
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

> On Tue, Apr 08, 2008 at 08:39:21PM +0200, Ingo Molnar wrote:
> > so the pure presence of the e1000e module breaks the e1000 driver. That 
> > is a regression and a bug that should be fixed.
> 
> I think you've found the wrong problem ... it looks deliberate to me 
> that enabling e1000e disables e1000 from claiming the PCI IDs (see the 
> PCIE() macro right before the e1000_pci_tbl in 
> drivers/net/e1000/e1000_main.c).
> 
> The question is why e1000e isn't claiming the device ...

because i have e1000 built-in and dont load the e1000e module at all. 
That worked before and doesnt work now.

the solution is rather straightforward: if E1000 is built-in then E1000E 
should be built-in as well or disabled (i.e. it should not be possible 
to build it as a module in that case) - because the PCI ID stealing 
trick now connects the two drivers unconditionally. [ If e1000 is a 
module then e1000e can be a module (or disabled) - this would be the 
most common configuration. ]

	Ingo
