Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbYDKRaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbYDKRaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbYDKRaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:30:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:2670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031AbYDKRaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,642,1199692800"; 
   d="scan'208";a="315021331"
Message-ID: <47FF9F2D.1040107@intel.com>
Date: Fri, 11 Apr 2008 10:26:05 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, NetDev <netdev@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [patch] e1000=y && e1000e=m regression fix
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org>
In-Reply-To: <20080411164542.GA4066@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Apr 2008 17:26:44.0695 (UTC) FILETIME=[36B36E70:01C89BF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Apr 11, 2008 at 09:22:56AM -0700, Kok, Auke wrote:
>> You don't provide a solution, nor does anyone, and I don't see any solution to
>> what you want but to completely cancel this driver split.
>>
>> And I'm _not_ going to do that.
> 
> As a start we could do two driver keyed off a single Kconfig variable.
> And then find a way to get users informed that they might need to
> enabled the other one


This is probably the ugliest way to do it, but I just checked and if E1000=m then
automatically becomes E1000E=m etc.

Using 'default' will not work as people will misunderstand the issue and disable
e1000e anyway, while they often need e1000e instead of e1000.

Yes, this does mean that it's impossible to have e1000 but not enable e1000e, but
given the threads I think this is becoming more reasonable then ever for this
particular issue.

---
e1000e: select automatically if e1000 is enabled

This terrible Kconfig hack prevents most people from accidentally forgetting to
enable e1000e where appropriate - just enable it by default. This patch should be
removed once e1000e merge is done and settled.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index ec764a9..19b5b2b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1968,6 +1968,7 @@ config DL2K
 config E1000
 	tristate "Intel(R) PRO/1000 Gigabit Ethernet support"
 	depends on PCI
+	select E1000E
 	---help---
 	  This driver supports Intel(R) PRO/1000 gigabit ethernet family of
 	  adapters.  For more information on how to identify your adapter, go
