Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbYDKJA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbYDKJA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbYDKI7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:59:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759588AbYDKI7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:59:44 -0400
Date: Fri, 11 Apr 2008 10:59:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Jeff Garzik <jeff@garzik.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       NetDev <netdev@vger.kernel.org>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <greg@kroah.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression] e1000e broke e1000
Message-ID: <20080411085907.GA10801@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FD64B5.1050309@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD64B5.1050309@tmr.com>
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


* Bill Davidsen <davidsen@tmr.com> wrote:

>> the solution is rather straightforward: if E1000 is built-in then 
>> E1000E should be built-in as well or disabled (i.e. it should not be 
>> possible to build it as a module in that case) - because the PCI ID 
>> stealing trick now connects the two drivers unconditionally. [ If 
>> e1000 is a module then e1000e can be a module (or disabled) - this 
>> would be the most common configuration. ]
>
> And this would seem to break the most common means of testing a new 
> driver for existing (and working!) hardware, which is to build both 
> drivers as modules, install the new one, and if it appears to have 
> problems either remove and insert the old driver by hand, or boot 
> forcing the old driver.
>
> I can't be the only person who tests kernels on machines I wouldn't 
> use to build a kernel, and uses modprobe.conf to test new driver 
> functionality.

yes, but note that the breakage you are talking about is not caused my 
patch, it is caused by the planned change to remove those PCI IDs from 
e1000.

my suggested change only solves part of the more general problem you 
touch upon. (and it does not make it worse in any way)

	Ingo
