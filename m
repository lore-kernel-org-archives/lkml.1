Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXFVNe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXFVNe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXFVNet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:34:49 -0400
Received: from mail.atmel.fr ([81.80.104.162]:39011 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbXFVNes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:34:48 -0400
Message-ID: <467BCFCF.6020509@rfo.atmel.com>
Date: Fri, 22 Jun 2007 15:34:07 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Marc Pignat <marc.pignat@hevs.ch>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
References: <467A4532.40301@rfo.atmel.com> <200706211657.49427.marc.pignat@hevs.ch> <467A9F43.1050007@rfo.atmel.com> <200706220828.18750.marc.pignat@hevs.ch>
	 <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins :
> Aren't you just guessing there?  Those kunmap_atomics in at91_mci.c
> may look wrong to you, but they're not incorrect (so long as sg->offset
> falls within the page, as it must do here to make sense of the page).
> Especially not on ARM, where kunmap_atomic actually has no interest
> in the argument passed.  And the oops was in the flush_dcache_page.
> 
> If you actually reproduced Nicolas' problem on ARM, and verified
> that your patch then fixes it, please let us know: that will be
> remarkably interesting.

Patch tested without success. Indeed, I always see the Oops with 
Marc's patch.

> I believe I posted the correct fix last night (or at least a safe fix
> for now: Christoph Lameter may prefer to undo it and change ARM's
> dma_mapping at leisure later), checking PageSlab in page_mapping;
> and Linus has already put that one into his git tree.

Here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b9bae3402572dc50a1e084c5b1ae5117918ef0f0

> But it would be good to hear from Nicolas whether that indeed fixes
> his oops: I couldn't actually try my patch on ARM either.

Ok tested on Atmel ARM AT91 (at91sam9263), this fixes this oops.

Thanks a lot to all of you for your precise help.

Regards,
-- 
Nicolas Ferre


