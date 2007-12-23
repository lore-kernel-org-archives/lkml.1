Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXLWFKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXLWFKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXLWFJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:09:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47846 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXLWFJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:09:57 -0500
Message-ID: <476DED9D.7070604@garzik.org>
Date: Sun, 23 Dec 2007 00:09:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Dec 2007, Jeff Garzik wrote:
>> But regardless of problems, enabling should be done globally, not per
>> device...
> 
> I'm ok with trying the "globally" idea, but it has to be "globally but 
> only if absolutely required".
> 
> And quite frankly, how do you tell whether it's absolutely required or 
> not?
> 
> I have an idea: the drivers that really need it will do a "please enable 
> MMCONFIG, because I will need it" thing?
> 
> Ok?
> 
> And then, since we *need* such a "pci_enable_mmconfig()" call anyway, why 
> not let the driver give which device it controls too, so that we can print 
> out the information (in case the machine then hangs immediately 
> afterwards), and perhaps - if it is shown to help - only do the MMCONFIG 
> cycles for that particular device?
> 
> Sounds like a plan?

As long as pci_enable_ext_cfg_space(pdev) enables extended accesses for 
-all- devices, the plan is mostly sound.

That largely eliminates the inconsistency issue.

The only thing I would worry about is whether "config space suddenly 
grew larger" condition will confuse userspace -- but that is NOT an 
objection, just a worry.

	Jeff



