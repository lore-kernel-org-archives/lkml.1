Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbXIUNKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbXIUNKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXIUNKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:10:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36450 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXIUNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:10:35 -0400
Date: Fri, 21 Sep 2007 14:06:00 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, lethal@linux-sh.org, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
Message-ID: <20070921130600.GB20277@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl> <20070921010349.2caee558.akpm@linux-foundation.org> <46F3BC3A.8060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F3BC3A.8060703@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:42:34PM +0200, Gerd Hoffmann wrote:
> Andrew Morton wrote:
> > On Thu, 20 Sep 2007 18:28:49 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> > 
> >>  Move the hadover message to after the boot console has been released to 
> >> avoid bad interactions between it and the real console.
> 
> [ longish problem discussion snipped ]
> 
> >> considered fully disabled.  Below is a change which makes the problem 
> >> disappear for me, but I suppose there was a deliberate reason for placing 
> >> the printk() where it is now and nowhere else.
> 
> Well, I placed the printk there is for user interface reasons.  I think
> especially in case the early console and the real console go to
> different physical devices it is useful to have the reason it stops
> printing messages displayed on the early console.  So people don't think
> the computer hangs although it just prints messages elsewhere ...
> 
> If that isn't going to work due to two instances not knowing each other
> (kernel & firmware) should not mess with the same physical device, then
> I'd just drop the printk.  And I see no pretty and easy way around that
> issue :-(
> 
> We could do the printk and unregister before we setup the new console.
> Which has the drawback that we are in trouble in case the setup() call
> for the new console fails ...
> 
> We could split the printk into two, one early ("trying to setup new
> console foo") which goes to the boot console, then (assuming the setup
> worked ok) unregister silently and print a message about the successful
> init and boot console unregister on the new console only.  Which results
> in two lines being printed for the handover when both consoles address
> the same physical device.  Not that nice IMHO, but maybe still the best
> way to handle it.

I had an issue with the console initialisation on serial ports, which I
discovered during my PXA work.  My reason for asking about the kernel
versions (which Andrew forwarded to LKML) is to determine whether the
report is as a result of those changes, or lack of those changes.

Those -mm versions with git-arm in probably have that change.  Ergo
the importance to answer this question about kernel versions.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
