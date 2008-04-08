Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYDHTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYDHTdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYDHTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:33:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45519 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYDHTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:33:03 -0400
Date: Tue, 8 Apr 2008 13:32:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Re: [regression] e1000e broke e1000 (was: Re: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices)
Message-ID: <20080408193245.GG11962@parisc-linux.org>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408183921.GA20803@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 08:39:21PM +0200, Ingo Molnar wrote:
> so the pure presence of the e1000e module breaks the e1000 driver. That 
> is a regression and a bug that should be fixed.

I think you've found the wrong problem ... it looks deliberate to me that
enabling e1000e disables e1000 from claiming the PCI IDs (see the PCIE()
macro right before the e1000_pci_tbl in drivers/net/e1000/e1000_main.c).

The question is why e1000e isn't claiming the device ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
