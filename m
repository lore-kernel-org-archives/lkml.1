Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbXLTVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbXLTVL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbXLTVLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:11:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:54895 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbXLTVLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:11:48 -0500
Subject: Re: PCI resource problems caused by improper address rounding
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Richard Henderson <rth@twiddle.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
In-Reply-To: <20071218202234.GA24525@twiddle.net>
References: <47671377.6000405@redhat.com>
	 <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	 <47680489.6040809@redhat.com>
	 <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	 <20071218202234.GA24525@twiddle.net>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 08:10:42 +1100
Message-Id: <1198185042.6779.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That won't work, because PCI_BASE_ADDRESS_MEM_TYPE_64 controls how
> many bits need to be written back to the BAR.  If we changed that
> to PCI_BASE_ADDRESS_MEM_TYPE_32, we wouldn't clear the high 32-bits
> of the BAR.
> 
> > ... and that would be an X server issue!).
> 
> Of course, fixing the X server to *handle* 64-bit BARs is the correct
> solution.  I've no idea how involved that is, but I have a sneeking
> suspicion that it uses that damned CARD32 datatype for everything.

A lot more than X needs to be fixed to handle 64-bit BARs btw. There's a
whole load of places in drivers/pci/* where we just puke if we see a
value >4G being assigned.

Now, there is some hope that the new X with libpciaccess can cope with
that, and even if it is broken, it would be much easier to fix, as X in
that case is no longer trying to bypass the kernel, but instead uses
proper kernel interfaces to map device resources.

That used to be Xorg pci-rework branch, though it might have been merged
in the  trunk by now.
 
Ben.

