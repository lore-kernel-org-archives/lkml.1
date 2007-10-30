Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbXJ3XeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbXJ3XeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXJ3Xd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:33:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbXJ3Xdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:33:55 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Wed, 31 Oct 2007 00:30:38 +0100
User-Agent: KMail/1.9.1
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       akpm@linux-foundation.org, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org> <alpine.LFD.0.999.0710301527320.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301527320.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710310030.38794.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Actually, I guess the bad case wasn't "not listed at all", but incorrectly
> listed - so the probing would go to the wrong address, not find any
> devices, and then promptly result in an unusable machine with no hardware
> attached.

iirc they tended to hang for whatever reason when the mcfg
area was accessed, not just not detect anything.

>
> I _think_ (and hope) those machines were never released.

They were :/ The bug flowed from a Intel reference BIOS to lots of
production boards. 

> But even now, on 
> my main machine, I get "MCFG area at f0000000 is not E820-reserved", and

That's a different issue. The spec does not require it to be e820-reserved.
That was just a (bogus) heuristic originally added to handle the early BIOS
bug. Even BIOS where the mcfg is fine do not reserve it there.

There were some patches to check it against ACPI resources (which
was presumably better specification conforming and more importantly
similar to what M$ does). I'm not sure that fixed all problems and
made the e820 check obsolete though.

> Basically, the resource allocation for mmconf has always been broken
> (largely by *design* by Intel!). And by being broken, it has been
> unreliable.

Well the overlapping to MMIO would have been fine as design if BIOS had
gotten it right.  Trying to design things that BIOS can't get it wrong
is probably futile -- the BIOSes would just find more subtle ways to break.
The real problem I guess was that Linux was trying to use it before 
Windows which is usually a bad idea regarding BIOS support at least
in the Desktop/Laptop space. 

-Andi
