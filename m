Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYDDVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYDDVb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYDDVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:31:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35029 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYDDVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:31:15 -0400
Subject: Re: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <47F69965.7030303@intel.com>
References: <47F69965.7030303@intel.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 14:31:09 -0700
Message-Id: <1207344669.26869.33.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 14:11 -0700, Kok, Auke wrote:
> >From kernel 2.6.26 onward all *PCI Express* device IDs previously
> supported by e1000 will be moving to the e1000e driver.  This includes
> ich8 and ich9 onboard LAN, server 5000 platform onboard LAN (es2) and
> 82571/2/3 chipset based adapters and variants.
> 
> If you have not already enabled CONFIG_E1000E make sure that you do so.
> You can already do this with 2.6.25.  From 2.6.26 on this change will be
> required if you have such a device.

I've been bitten by one or two of these in the past.  Can we do
something like this for a couple of releases?

Shouldn't this default the E1000E config option to the same thing that
people have the E1000 set as?  It should catch the dumb people like me
who's enter key gets held down during a 'make oldconfig'. :)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 3a0b20a..aa0fe14 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2005,6 +2005,7 @@ config E1000_DISABLE_PACKET_SPLIT
 config E1000E
        tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
        depends on PCI
+       default E1000
        ---help---
          This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
          ethernet family of adapters. For PCI or PCI-X e1000 adapters,


-- Dave

