Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXLWELl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXLWELl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXLWELc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:11:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51354 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbXLWELc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:11:32 -0500
Message-ID: <476DDFEE.3010009@garzik.org>
Date: Sat, 22 Dec 2007 23:11:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The problem is that it isn't enough that it works on common machines with 
> good hardware. The problem is that we end up chasing insane bugs, wasting 
> peoples valuable time and effort, on those *few* - out of *millions* - of 
> machines that then surprisingly don't work.
> 
> And "surprisingly" is definitely the watch-word. That includes silently 
> just not booting (because the first time anybody tries to do a PCI config 
> cycle access, the machine just locks up) to some really *odd* behaviour 
> (ie everything works fine *except* that reading the PCI card ID from a 
> few cards returns a value of 0x0001 rather than the correct one).

> The fact is, we're currently turning off MMCONFIG very aggressively, 
> exactly because it has caused problems. So most people never even use 
> MMCONFIG when it's enabled, because all of our sanity checks that turn it 
> off again. And it still has caused odd problems.

Yes, I know all this.  I am quite aware of the situation.

My core assertion:  the present situation -- turning off MMCONFIG 
aggressively -- is greatly preferable to adding 
pci_enable_mmconfig_accesses(pdev).

IOW, don't add a new API.  Keep doing what we're doing today.

Today, we have a consistent "all or none" model for mmconfig.  Any 
per-device mmconfig enabling introduces pain and inconsistency, in both 
the kernel and userland.

Users with devices that REQUIRE extended config accesses should buy 
machines with known good mmconfig.  The situation will sort itself out 
from there.  We don't need ugly hacks like 
pci_enable_mmconfig_for_this_device().

	Jeff


(second response, for other paragraphs, following in separate email.  I 
wanted to underscore the core API issue...)


