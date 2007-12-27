Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXL0LrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXL0LrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXL0LrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:47:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45925 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXL0LrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:47:17 -0500
Message-ID: <4773908E.80600@garzik.org>
Date: Thu, 27 Dec 2007 06:46:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Loic Prylli <loic@myri.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru> <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org> <476F6047.50100@garzik.org> <alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Well, the *current* behaviour as far as setup is concerned is 
> unacceptable. But yes, longer term, we should be able to just have quirk 
> entries for saying "enable mmconfig because I know it's safe", except we 
> should not enable them until after the core PCI probing has completed.


IMO that should be an arch decision, buried somewhere in arch/x86.

If other arches implement extended config space sanely -- and possibly 
via some arch-specific means that is /not/ mmconfig -- then they should 
be able to make an arch decision that extended PCI config space accesses 
Just Work(tm).

For such arches, pci_enable_ext_cfg_space(pdev) would be a no-op, always 
returning success.

	Jeff


