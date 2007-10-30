Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXJ3WXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXJ3WXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXJ3WW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:22:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbXJ3WW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:22:58 -0400
Date: Tue, 30 Oct 2007 15:22:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <200710301504.36972.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <200710301504.36972.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Jesse Barnes wrote:
>
> The per-device flag is fine with me, but I should make something clear:
> 
> MMCONFIG IS NOT BROKEN!

Trust me, it is.

The particular problem _you_ had with it is only a small small part of the 
bugs we have had.

> What's broken is our PCI probing with certain address space layouts that 
> include MMCONFIG space.

No. You really don't see the big picture. There's been tons of problems 
with MMCONFIG. Like the fact that other devices have their IO regions 
registered on top of it, because the MMCONFIG thing was done as a hidden 
resource. Or the fact that the area claimed was too small. Or too large. 
Or not listed at all.

The whole thing is a total disaster. I told Intel engineers literally 
*years* ago to not do that idiotic "hidden IO resources that are described 
by firmware that then inevitably gets things wrong", and yet what happens? 
Every single time.

			Linus
