Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbXLUAlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbXLUAlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbXLUAlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:41:42 -0500
Received: from are.twiddle.net ([64.81.246.98]:40834 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbXLUAll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:41:41 -0500
Date: Thu, 20 Dec 2007 16:39:13 -0800
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071221003913.GA6220@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
	Keith Packard <keithp@keithp.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <20071218215143.GA24769@twiddle.net> <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org> <20071220215204.GA5636@twiddle.net> <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 02:24:48PM -0800, Linus Torvalds wrote:
> I'm not exactly 100% happy with it, but it does mean that if we need a big 
> area, we'll relax the suggested starting point by that amount. It's not 
> wonderful, but it essentially admits that the minimum for the allocations 
> is really just a hint, and if we need lots of space for a resource, we'll 
> relax the minimum point appropriately.

This breaks in odd cases where the amount of memory in the system
is not a nice round number.  Like throwing two 128MB sticks into
a system that already has 2gb.  A 512MB allocation will get placed
back at 2gb, on top of the end of ram.  In order to get this kind
of thing to work, you'd have to have a hard and a soft minimum.

Even then, any random large allocation is going to ignore that
buffer that you added.  It'd be better if we could still tie this
ignoring of the buffer to whether the bios placed the resource
there in the first place.

Perhaps this is one of those things that just aren't going to be
solved properly without an xserver upgrade...


r~
