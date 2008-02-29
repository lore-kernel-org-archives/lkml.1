Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbYB2WbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbYB2WbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYB2WbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:31:10 -0500
Received: from c60.cesmail.net ([216.154.195.49]:42565 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbYB2WbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:31:08 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080229211513.GI27212@elte.hu>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv>  <20080229211513.GI27212@elte.hu>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 17:31:05 -0500
Message-Id: <1204324265.2316.70.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 22:15 +0100, Ingo Molnar wrote:
> * Pavel Roskin <proski@gnu.org> wrote:
> 
> > I already know what USB folks will say.  They want proprietary drivers 
> > to be in the userspace.  I doubt ndiswrapper will ever be ported to 
> > the userspace.  It's much more likely that some other approach will be 
> > used.
> 
> btw., what are the technical reasons why ndiswrapper cannot be done in 
> userspace, much like the (wildly successful) FUSE concept?

ndiswrapper contains essentially two drivers in one - PCI and USB.  The
PCI driver uses DMA, which should be a strong argument for keeping it in
the kernel.

As for the USB driver, it may be possible, but some infrastructure may
still be missing.

ndiswrapper needs to register network devices.  For wireless devices, it
needs to be a device with wireless extension support.  I don't think
it's currently possible from the userspace.

> what's the main hardware access method of ndiswrapper - only PIO, or 
> mmio as well? In the former case, ioperm() should work, in the latter 
> case, mmap()ing the device aperture should work.

Both.  I'm afraid DMA is the real problem here.

> Frankly, it would be a great approach for the following reason: it would 
> be _far_ easier for people to write a proper free driver, if the NDIS 
> driver was in user-space, in a nicely debuggable, traceable, observable 
> environment. I dont really see what the technical difficulties there are 
> here.

I agree that it would be great, but it's quite a lot of work.

-- 
Regards,
Pavel Roskin
