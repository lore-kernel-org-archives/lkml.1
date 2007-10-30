Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXJ3RoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXJ3RoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbXJ3RoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:44:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803AbXJ3RoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:44:12 -0400
Date: Tue, 30 Oct 2007 10:43:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <20071030102820.47a6e365@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0710301039230.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com>
 <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <20071030102820.47a6e365@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Arjan van de Ven wrote:
> 
> something like
> int pci_enable_mmconfig(struct pci_dev *pdev) ?

Yes, that looks fine. It also matches the kinds of things drivers already 
have to do (ie enable DMA, MSI etc), both conceptually and from a purely 
syntactic/practical standpoint.

I think mmconfig and MSI have a lot in common, in that both are relatively 
new features and both have had issues that made them not work well.

> sounds like a very solid plan to me...
> 
> > Maybe somebody inside Intel could just clarify the documentation, and 
> > change it from "you're not supposed to mix" to "mix all you want". 
> 
> I'll see what I can do ;)

Well, let's see if "pci_enable_mmconfig()" works out first. There probably 
aren't more than a few drivers that would be interested in this anyway, so 
it's probably fine.

And by the time mmconfig is commonly used, probably all the teething 
problems are long gone, so we could plan on a "in five years, maybe we 
could even enable it by default" thing?

		Linus
