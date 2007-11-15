Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXKOLvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXKOLvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXKOLux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:50:53 -0500
Received: from paragon.brong.net ([74.52.187.94]:57470 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbXKOLuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:50:52 -0500
Date: Thu, 15 Nov 2007 22:50:49 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       robm@fastmail.fm
Subject: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel Bugs)
Message-ID: <20071115115049.GA8297@brong.net>
References: <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 09:53:38PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 14 Nov 2007, Linus Torvalds wrote:
> > 
> > So even at 100% dirty limits, it won't let you dirty more than 1GB on the 
> > default 32-bit setup.
> 
> Side note: all of these are obviously still just heuristics. If you really 
> *do* run on a 32-bit kernel, and you want to have the pain, I'm sure you 
> can just disable the dirty limits with a one-liner kernel mod. And if it's 
> useful enough, we can certainly expose flags like that.. Not that I expect 
> that much anybody else will ever care, but it's not like it's wrong to 
> expose the silly heuristics the kernel has to users that have very 
> specific loads.
> 
> That said, I still do hope you aren't actually using HIGHMEM64G. I was 
> really hoping that the people who had enough moolah to buy >4GB of RAM had 
> long since also upgraded to a 64-bit machine ;)

I'm afraid we are, which probably explains it.

We have a bunch of 64 bit machines, but this particular machine
is one of our somewhat more ancient IBM x235 machines.  It's
got stacks of fast SCSI drives and a couple of hyperthreading
Xeons in it.  Very nice machine in its day, and very reliable
which is why we have kept them, even though at 6RU it chews
through disk space.

Unfortunately none of the 64 bit machines are world facing,
and we're running HIGHMEM64G on a bunch of machines both for
consistency value and because we only have one machine left
with only 2Gb.

I guess we'll be doing the one-liner kernel mod and testing
that then.  I'd certainly like to build a test case anyway
so I'm not spending too much time rebooting that machine,
it's also our outbound SMTP gateway.

And I'll keep in mind finding a 64 bit capable machine for
the role when I can.

Thanks for the feedback on this - I'll come back with more
details once we've done some testing, but this sounds likely,
and I don't think DCC is going to change how it works, so
we're stuck supporting it.

Bron.
