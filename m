Return-Path: <linux-kernel-owner+w=401wt.eu-S1765712AbXJPGSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765712AbXJPGSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXJPGSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:18:09 -0400
Received: from mx2.go2.pl ([193.17.41.42]:43111 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803AbXJPGSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:18:08 -0400
X-Greylist: delayed 62882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 02:18:08 EDT
Date: Tue, 16 Oct 2007 08:21:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Maciej W\. Rozycki" <macro@linux-mips.org>
Cc: Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-ID: <20071016062108.GB1000@ff.dom.local>
References: <20071015125301.GC3015@ff.dom.local> <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 06:03:20PM +0100, Maciej W. Rozycki wrote:
> On Mon, 15 Oct 2007, Jarek Poplawski wrote:
> 
> > Could you explain why cancel_work_sync() is better here than
> > flush_scheduled_work() wrt. rtnl_lock()?
> 
>  Well, this is actually the bit that made cancel_work_sync() be written in 
> the first place.  The short story is the netlink lock is most probably 
> held at this point (depending on the usage of phy_disconnect()) and there 
> is also an event waiting in the queue that requires the lock, so if 
> flush_scheduled_work() is called here a deadlock will happen.
> 
>  Let me find a reference for a longer story...:
> 
> http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=Pine.LNX.4.64N.0610031509380.4642%40blysk.ds.pg.gda.pl
> 
> and then discussed again:
> 
> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0612.0/0593.html
> 

Yes, it's all right here. Sorry for bothering - I should've found this
by myself.

I've still some doubts about this possible enable_irq() after
free_irq(). If it's the only handler the status would be changed again
and at least some of this code in check_irq_resend() would be run, but
I can miss something again or/and this doesn't matter, as well.

Thanks,
Jarek P.
