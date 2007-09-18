Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXIRTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXIRTEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXIRTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:04:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756694AbXIRTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:04:03 -0400
Date: Tue, 18 Sep 2007 12:03:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu>
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> 
> Alright, here is the same patch inline with s/recommended/required/ language:

Well, the thing is, I'm not at all sure that I agree with this.

If you use ioport_map/unmap, then you really *should* access them with the 
proper iomem accessors (ioread/iowrite). The fact that it may happen to 
work (when using the default lib/iomap.c implementation, at least) on 
some architectures and with the current implementation still doesn't mean 
that you should necessarily use readb/writeb.

After all, you cannot use "inb/outb" on it, even if would happen to be an 
IO address.

So what is this usage that wants to use the bogus accessor? Why not fix 
that instead of adding documentation for something that is very arguably 
something we want to *avoid* having people do!

		Linus
