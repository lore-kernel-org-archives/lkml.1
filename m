Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbXLKXRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbXLKXRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXLKXRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:17:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20002 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXLKXRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:17:16 -0500
Date: Tue, 11 Dec 2007 15:15:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mbligh@google.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org, netdev@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: 2.6.24-rc4-mm1
Message-Id: <20071211151543.f3b73c62.randy.dunlap@oracle.com>
In-Reply-To: <475F0C6C.20900@intel.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com>
	<20071211123705.844aac24.akpm@linux-foundation.org>
	<475F00A2.6020406@intel.com>
	<20071211141040.a1c6f316.akpm@linux-foundation.org>
	<475F0C6C.20900@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 14:17:16 -0800 Kok, Auke wrote:

> Andrew Morton wrote:
> > On Tue, 11 Dec 2007 13:26:58 -0800
> > "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> > 
> >> Andrew Morton wrote:
> >>> On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:
> >>>
> >>>>> - Lots of device IDs have been removed from the e1000 driver and moved
> >>>>> over
> >>>>>  to e1000e.  So if your e1000 stops working, you forgot to set
> >>>>> CONFIG_E1000E.
> >>>>>
> >>>>>
> >>>> Wouldn't it make sense to just default this to on if E1000 was on, rather
> >>>> than screwing
> >>>> everybody for no good reason (plus breaking all the automated testing, etc
> >>>> etc)?
> >>>> Much though I love random refactoring, it is fairly painful to just keep
> >>>> changing the
> >>>> names of things.
> >>> (cc netdev and Auke)
> >>>
> >>> Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
> >>> CONFIG_E1000 was set to.
> >> which is "y" for x86 and friends, ppc, arm and ia64 through 'defconfig'. the
> >> Kconfig files do not have defaults in them.
> > 
> > I wouldn't be looking at defconfig files - I don't think many people use
> > them.  Most people use their previous config, via oldconfig.
> > 
> > So what we want here is to give them E1000E if they had previously been
> > using E1000.  I don't know how one would do this in Kconfig.
> 
> ditto. I doubt that "SELECT E1000E" would be a good idea here (maybe not even
> work), and I can't think of anything else.

"default E1000" in E1000E seems to work for me.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Make E1000E default to the same kconfig setting as E1000,
at least for -mm testing.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc4-mm1.orig/drivers/net/Kconfig
+++ linux-2.6.24-rc4-mm1/drivers/net/Kconfig
@@ -1986,6 +1986,7 @@ config E1000_DISABLE_PACKET_SPLIT
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI
+	default E1000
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
