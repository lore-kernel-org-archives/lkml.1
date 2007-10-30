Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbXJ3WiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbXJ3WiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJ3WiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:38:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbXJ3WiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:38:14 -0400
Date: Tue, 30 Oct 2007 15:38:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710301527320.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <200710301504.36972.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Linus Torvalds wrote:
>
> No. You really don't see the big picture. There's been tons of problems 
> with MMCONFIG. Like the fact that other devices have their IO regions 
> registered on top of it, because the MMCONFIG thing was done as a hidden 
> resource. Or the fact that the area claimed was too small. Or too large. 
> Or not listed at all.

Actually, I guess the bad case wasn't "not listed at all", but incorrectly 
listed - so the probing would go to the wrong address, not find any 
devices, and then promptly result in an unusable machine with no hardware 
attached.

I _think_ (and hope) those machines were never released. But even now, on 
my main machine, I get "MCFG area at f0000000 is not E820-reserved", and 
probably the only reason the PCI layer doesn't overwrite it is because it 
does show up as a PnP region, and I have pnp support enabled.

Basically, the resource allocation for mmconf has always been broken 
(largely by *design* by Intel!). And by being broken, it has been 
unreliable.

			Linus
