Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZLUEur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZLUEur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZLUEuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:50:46 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25100 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZLUEuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:50:44 -0500
Subject: Re: [PATCH 0/12] pci: update pci bridge resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4B2ED29B.7060108@kernel.org>
References: <4B2BEC0E.3050909@kernel.org>
	 <1261352672.26429.41.camel@dc7800.home>  <4B2ED29B.7060108@kernel.org>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 21:44:52 -0700
Message-Id: <1261370692.26429.78.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 17:42 -0800, Yinghai Lu wrote:
> Bjorn Helgaas wrote:
> > On Fri, 2009-12-18 at 12:54 -0800, Yinghai Lu wrote:
> >> this patche set is trying to update pci bridge BAR when that BAR is big enough.
> >>
> >> default it is disabled.
> >>
> >> could use pci=try=2 to enable it.
> > 
> > I think you mean "when the BAR is *not* big enough."  And strictly
> > speaking, I think you're concerned with the bridge *window*, which isn't
> > actually a bridge BAR.
> 
> in PCI bridge to bridge spec 1.1, page 38, 3.2.5.1 still call them bridge "Base Address Registers"
> 
> so should be fine we call them Bridge BAR, 
> 
> and we still have device BAR...

PCI bridges have optional BARs, described as you point out in section
3.2.5.1.  These work the same as BARs on any other PCI device, and your
patches aren't concerned with these.

Your patch series is primarily concerned with the bridge Base & Limit
registers described in sections 3.2.5.6 (I/O), 3.2.5.8 (memory), and
3.2.5.9 (prefetchable memory).  These define the address ranges
forwarded from one bridge interface to the other.  The spec doesn't have
a nice term for these ranges, but they're often referred to as "windows"
or "apertures" because they are the areas where you can "see through"
the bridge to devices on the other side.

Bjorn


