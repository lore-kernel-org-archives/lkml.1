Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbXLWFBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbXLWFBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXLWFA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:00:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXLWFA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:00:56 -0500
Date: Sat, 22 Dec 2007 21:00:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DE98F.2010009@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Jeff Garzik wrote:
> 
> But regardless of problems, enabling should be done globally, not per
> device...

I'm ok with trying the "globally" idea, but it has to be "globally but 
only if absolutely required".

And quite frankly, how do you tell whether it's absolutely required or 
not?

I have an idea: the drivers that really need it will do a "please enable 
MMCONFIG, because I will need it" thing?

Ok?

And then, since we *need* such a "pci_enable_mmconfig()" call anyway, why 
not let the driver give which device it controls too, so that we can print 
out the information (in case the machine then hangs immediately 
afterwards), and perhaps - if it is shown to help - only do the MMCONFIG 
cycles for that particular device?

Sounds like a plan?

		Linus
