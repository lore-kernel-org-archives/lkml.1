Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbXIRWRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbXIRWRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXIRWRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:17:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:54121 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbXIRWRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:17:12 -0400
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 08:16:14 +1000
Message-Id: <1190153775.6403.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 12:03 -0700, Linus Torvalds wrote:
> 
> On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> > 
> > Alright, here is the same patch inline with s/recommended/required/ language:
> 
> Well, the thing is, I'm not at all sure that I agree with this.
> 
> If you use ioport_map/unmap, then you really *should* access them with the 
> proper iomem accessors (ioread/iowrite). The fact that it may happen to 
> work (when using the default lib/iomap.c implementation, at least) on 
> some architectures and with the current implementation still doesn't mean 
> that you should necessarily use readb/writeb.
> 
> After all, you cannot use "inb/outb" on it, even if would happen to be an 
> IO address.
> 
> So what is this usage that wants to use the bogus accessor? Why not fix 
> that instead of adding documentation for something that is very arguably 
> something we want to *avoid* having people do!

Agreed.

ioremap -> readb/writeb
ioport_map/pci_iomap -> ioread/iowrite

and nothing else should be allowed.

Cheers,
Ben.


