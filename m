Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXJ3WfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXJ3WfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXJ3WfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:35:02 -0400
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:46041 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751574AbXJ3WfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:35:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 15:31:57 -0700
User-Agent: KMail/1.9.7
Cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <200710301504.36972.jbarnes@virtuousgeek.org> <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301531.58957.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2007 3:22 pm Linus Torvalds wrote:
> On Tue, 30 Oct 2007, Jesse Barnes wrote:
> > The per-device flag is fine with me, but I should make something
> > clear:
> >
> > MMCONFIG IS NOT BROKEN!
>
> Trust me, it is.
>
> The particular problem _you_ had with it is only a small small part
> of the bugs we have had.
>
> > What's broken is our PCI probing with certain address space layouts
> > that include MMCONFIG space.
>
> No. You really don't see the big picture. There's been tons of
> problems with MMCONFIG. Like the fact that other devices have their
> IO regions registered on top of it, because the MMCONFIG thing was
> done as a hidden resource. Or the fact that the area claimed was too
> small. Or too large. Or not listed at all.

Yeah, that's definitely a problem, and would be a firmware bug.  There's 
no doubt that firmwares have had trouble with this in the past, but 
given that Vista now relies on this stuff working, it's a lot more 
likely to be reliable in current and future systems.

> The whole thing is a total disaster. I told Intel engineers literally
> *years* ago to not do that idiotic "hidden IO resources that are
> described by firmware that then inevitably gets things wrong", and
> yet what happens? Every single time.

I don't disagree there.  I'm just saying the actual mechanism is fine 
(as illustrated by the numerous non-PC ports of Linux), and this 
particular problem, at least, isn't really specific to how MMCONFIG is 
described or configured by the firmware and OS, it's simply a Linux 
problem.

But like I said, the per-device flag Arjan suggested is fine with me...

Jesse
