Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbXIRVbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbXIRVbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbXIRVaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:30:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43687 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXIRVav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:30:51 -0400
Message-ID: <46F04386.8010209@garzik.org>
Date: Tue, 18 Sep 2007 17:30:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>  <20070918113401.6a8a737f@the-village.bc.nu>  <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>  <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>  <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>  <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>  <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>  <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org> <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com> <alpine.LFD.0.999.0709181408390.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709181408390.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The old situation with SATA drivers that had
> 
> 	if (iomem)
> 		writel(..)
> 	else
> 		outl(..)
> 
> in the cases that needed it (and used hardcoded writel/outl in the cases 
> that didn't) was an example of code that "in theory" is faster. But 
> dammit, in practice that mattered not one whit, and what iomap() tries to 
> do is to attack the _real_ problem we had in that area. 
> 
> Which had nothing what-so-ever to do with any branches.

And none of those issues are a factor at all in ath5k (which spawned 
this sub-discussion), or indeed many other drivers.  The above code you 
cite is -generic-, hardware agnostic code.

Most new hardware is MMIO-only, making ioread32() only for drivers that 
care about legacy IO support, something that is being slowly phased out. 
  e.g. legacy IDE, legacy 10/100 mbps ethernet NICs with the dual 
MMIO/PIO register spaces.

	Jeff



