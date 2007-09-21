Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXIUOqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXIUOqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXIUOqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:46:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56509 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbXIUOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:46:00 -0400
Date: Fri, 21 Sep 2007 15:45:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, kraxel@redhat.com, lethal@linux-sh.org,
       rgetz@blackfin.uclinux.org, vapier.adi@gmail.com
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
Message-ID: <20070921144523.GD20277@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl> <20070921010349.2caee558.akpm@linux-foundation.org> <Pine.LNX.4.64N.0709211428300.2724@blysk.ds.pg.gda.pl> <20070921134331.GC20277@flint.arm.linux.org.uk> <Pine.LNX.4.64N.0709211454570.2724@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0709211454570.2724@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:36:05PM +0100, Maciej W. Rozycki wrote:
> On Fri, 21 Sep 2007, Russell King wrote:
> > You can find the fix in the mbox archive:
> > 
> >  http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cut/arm:devel.mbox
> 
>  Hmm, nothing of relevance there.

Hmm, it does help to occasionally run the script which uploads the
patches and stuff.  Also I typoed the URL:

 http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/arm:devel.mbox

>  I see no problem with implementing the ->pm() call as something like:
> 
> void zs_pm(struct uart_port uport, unsigned int state, unsigned int oldstate)
> {
> 	struct zs_port *zport = to_zport(uport);
> 
> 	if (state < 3)
> 		zport->regs[5] |= TxENAB;
> 	else
> 		zport->regs[5] &= ~TxENAB;
> 	write_zsreg(zport, R5, zport->regs[5]);
> }
> 
> itself, but it looks more like a workaround than a fix to me.  I'll have 
> to think about it and also double-check it is safe.  The SCC is about as 
> complicated as you can get with a serial port.

You will need the serial patch from the above mbox.

PS, Gerd's bouncing email address removed from the CC line.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
