Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbXJ3Wm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbXJ3Wm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXJ3WmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:42:19 -0400
Received: from outbound-mail-54.bluehost.com ([69.89.20.34]:38818 "HELO
	outbound-mail-54.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752902AbXJ3WmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:42:19 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 15:39:17 -0700
User-Agent: KMail/1.9.7
Cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org> <alpine.LFD.0.999.0710301527320.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301527320.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301539.18677.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2007 3:38 pm Linus Torvalds wrote:
> On Tue, 30 Oct 2007, Linus Torvalds wrote:
> > No. You really don't see the big picture. There's been tons of
> > problems with MMCONFIG. Like the fact that other devices have their
> > IO regions registered on top of it, because the MMCONFIG thing was
> > done as a hidden resource. Or the fact that the area claimed was
> > too small. Or too large. Or not listed at all.
>
> Actually, I guess the bad case wasn't "not listed at all", but
> incorrectly listed - so the probing would go to the wrong address,
> not find any devices, and then promptly result in an unusable machine
> with no hardware attached.

Yeah, busted BIOS (and I agree a poor design decision).

> I _think_ (and hope) those machines were never released. But even
> now, on my main machine, I get "MCFG area at f0000000 is not
> E820-reserved", and probably the only reason the PCI layer doesn't
> overwrite it is because it does show up as a PnP region, and I have
> pnp support enabled.

Unfortunately I think some such machines *were* released, only because 
the release engineers figured no one actually uses MMCONFIG yet 
(Windows == whole world of users), so why worry about that particular 
bug?

The "not E820-reserved" message is actually bogus.  I'll bet MMCONFIG 
works fine on your machine with Robert's patch and the disable decode 
stuff applied.

Jesse
