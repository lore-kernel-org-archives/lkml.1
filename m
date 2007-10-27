Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbXJ0TOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbXJ0TOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXJ0TOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:14:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3084 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751414AbXJ0TOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:14:42 -0400
Date: Sat, 27 Oct 2007 15:14:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Arnd Bergmann <arnd@arndb.de>, <gregkh@suse.de>,
       <linux-arch@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       <matthew@wil.cx>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
       <viro@zeniv.linux.org.uk>, <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, <adobriyan@gmail.com>
Subject: Re: [linux-usb-devel] USB HCD: avoid duplicate local_irq_disable()
In-Reply-To: <20071025183352.GB2176@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0710271513210.30287-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Greg KH wrote:

> On Tue, Oct 23, 2007 at 12:01:37AM -0400, Alan Stern wrote:
> > On Tue, 23 Oct 2007, Arnd Bergmann wrote:
> > 
> > > usb_hcd_flush_endpoint() has a retry loop that starts with a spin_lock_irq(),
> > > but only gives up the spinlock, not the irq_disable before jumping to the
> > > rescan label.
> > > 
> > > Split the spin_lock_irq into the retryable part and the local_irq_disable()
> > > that is only done once as a micro-optimization and slight cleanup.
> > 
> > I agree with your sentiment, but it would be better to solve this 
> > problem without using local_irq_disable().  The patch below does this.
> > 
> > ---
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Alan, is this something you want added to the tree and in before 2.6.24
> is out?

Yes.  It's a small thing, but we're better off keeping IRQ
enable/disable calls properly balanced.

Alan Stern

