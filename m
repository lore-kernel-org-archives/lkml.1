Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXJYSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXJYSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXJYSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:42:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbXJYSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:42:49 -0400
Date: Thu, 25 Oct 2007 11:33:52 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de, linux-arch@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, matthew@wil.cx,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, ralf@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, viro@zeniv.linux.org.uk,
       viro@ftp.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, adobriyan@gmail.com
Subject: Re: [linux-usb-devel] USB HCD: avoid duplicate local_irq_disable()
Message-ID: <20071025183352.GB2176@kroah.com>
References: <200710230328.33915.arnd@arndb.de> <Pine.LNX.4.44L0.0710222359290.13902-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710222359290.13902-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 12:01:37AM -0400, Alan Stern wrote:
> On Tue, 23 Oct 2007, Arnd Bergmann wrote:
> 
> > usb_hcd_flush_endpoint() has a retry loop that starts with a spin_lock_irq(),
> > but only gives up the spinlock, not the irq_disable before jumping to the
> > rescan label.
> > 
> > Split the spin_lock_irq into the retryable part and the local_irq_disable()
> > that is only done once as a micro-optimization and slight cleanup.
> 
> I agree with your sentiment, but it would be better to solve this 
> problem without using local_irq_disable().  The patch below does this.
> 
> ---
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Alan, is this something you want added to the tree and in before 2.6.24
is out?

thanks,

greg k-h
