Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXJaACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXJaACX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXJaACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:02:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbXJaACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:02:14 -0400
Date: Tue, 30 Oct 2007 17:02:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <20071030165202.14651248@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0710301659590.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com>
 <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <4727C126.8070000@shaw.ca> <20071030165202.14651248@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Arjan van de Ven wrote:
> 
> it's per device so that if you have have no users for this stuff,
> you'll never ever get bitten by bugs (be it linux or the bios).

Exactly. It's not that we care about trying to protect a system that 
really needs to use MMCFG - once you really *really* need it, you're 
screwed if it doesn't work.

But currently 99% of all systems will never need it, and for the broken 
platforms, that's a nice round 100%. So if we make code not use MMCFG by 
default, and you have to enable it for just those device drivers that 
really want it and care, you automatically avoid all the broken hardware, 
with no real downsides.

			Linus
