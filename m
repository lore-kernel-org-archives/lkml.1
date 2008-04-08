Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYDHTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYDHTqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYDHTqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:46:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:56219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYDHTp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,625,1199692800"; 
   d="scan'208";a="313848154"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [regression] e1000e broke e1000 (was: Re: [ANNOUNCE] e1000 toe1000e migration of PCI Express devices)
Date: Tue, 8 Apr 2008 12:43:00 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080408183921.GA20803@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [regression] e1000e broke e1000 (was: Re: [ANNOUNCE] e1000 toe1000e migration of PCI Express devices)
Thread-Index: AciZqK8ddXQSO8DBQcOLuBRTBuY5fQABCkiQ
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "NetDev" <netdev@vger.kernel.org>,
       "e1000-list" <e1000-devel@lists.sourceforge.net>,
       "linux-pci maillist" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, "Greg KH" <greg@kroah.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
X-OriginalArrivalTime: 08 Apr 2008 19:43:01.0039 (UTC) FILETIME=[C0F143F0:01C899B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Auke is out sick, so I'm responding...

Ingo Molnar wrote:
> this is a simple bzImage kernel, no modules at all. Here's the full
> regression report:

then why are you compiling e1000e as a module?  no "=y" in your kernel
means no support, and this kernel .config has e1000e supporting your
hardware.

your expectation is that e1000 once loaded on this device in a previous
kernel (2.6.24) so it should continue to work, right?  I see your point
but we are trying to make general improvements to both drivers, and the
best way forward was a split, in order to make the user experience
better by eliminating chances for regressions on older hardware.  
 
> v2.6.25-rc8 regresses relative to v2.6.24, with the following config,
> which config works fine in v2.6.24:

> the eth0 interface is not detected at all:
>    http://redhat.com/~mingo/misc/dmesg.e1000.bad

if you're running a no module kernel, you'll need to set CONFIG_E1000E=y
for your device to be detected.  

> so the pure presence of the e1000e module breaks the e1000 driver.
> That 
> is a regression and a bug that should be fixed.

The device IDs moved to e1000e, we don't want collisions between drivers
that support the same IDs, so to avoid those user support issues, we're
trying to make the process as painless as possible with announcements
and time.  The distros are already including the e1000e driver in their
builds and new installs with the new ID layout will automatically select
the correct driver for their hardware.

Users that take an upgrade to their kernel (with e1000e enabled) might
benefit if the distro upgrading that kernel included a post upgrade
script that migrated e1000e devices previously using e1000 in
modprobe.conf to alias ethX e1000e

If there is a more reasonable solution you can come up with I am
interested.

Jesse
