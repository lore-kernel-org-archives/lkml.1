Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYDHUeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYDHUeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYDHUdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:33:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44988 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYDHUdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:33:51 -0400
Date: Tue, 8 Apr 2008 22:33:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] e1000e broke e1000
Message-ID: <20080408203314.GA28952@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FBD34A.6080508@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> i repeat, it took me more than an hour to figure out why there's no 
>> networking on my laptop. Guess how much it takes for a plain user to 
>> figure out the same problem.
>
> A plain user would have obtained a working distro kernel, putting this 
> rare problem purely in the laps of people with highly unusual kernel 
> configs...
>
> But as noted in the announcement, the fix is for this is to continue 
> in the next step in the transition, then you only have one driver 
> claiming those IDs, for any given config.  No need for further Kconfig 
> tweakage.

i find it mindboggling and rather sad that you are still in denial :-(

this is an obvious regression to me, with a very simple fix. No other 
PCI driver breaks like this. We've got three thousand Kconfig options - 
it is clearly not realistic for users to keep such details in mind to 
avoid pitfalls. E1000=y && E1000E=m is uncommon but can easily happen. 
E1000=y && E1000E=m simply makes no sense in light of the PCI ID 
stealing that occurs if E1000E is enabled.

	Ingo
