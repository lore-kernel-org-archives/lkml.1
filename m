Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbYDUQTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbYDUQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYDUQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:19:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbYDUQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:19:31 -0400
Date: Mon, 21 Apr 2008 09:18:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PCI MAINTAINER change
In-Reply-To: <200804210855.28405.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0804210914030.2779@woody.linux-foundation.org>
References: <20080421062139.GA4901@suse.de> <20080421062806.GA4919@suse.de> <200804210855.28405.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, Jesse Barnes wrote:
> 
> And now I get to figure out just how much trouble I've gotten myself into...

Mwhahahaaa! Sucker. You'll find out.

The good news is that most of the time, the PCI code works fine. The bad 
news is that when it doesn't work, it's usually due to something *really* 
odd, like some magic motherboard device that has magic resources that 
aren't part of the standard PCI resource set and that clash with some of 
our resource allocation.

And they don't show up in the PnP lists because Windows never put anything 
that could clash with them, so there was no reason for the BIOS engineers 
to bother.

IOW, it's usually almost totally undebuggable crud like "driver X doesn't 
work on my machine", and then it turns out that it only happens on that 
particular motherboard that is totally identical to all other motherboards 
_except_ for that BIOS table not having the right reserved IO regions.

.. and then there's the pluggable PCI stuff, of course. I'm not sure 
whether you took that over too. That's a whole different set of issues.

			Linus
