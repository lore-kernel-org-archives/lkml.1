Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbXEVLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbXEVLX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXEVLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:23:19 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1994 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEVLXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:23:18 -0400
Date: Tue, 22 May 2007 13:20:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
Message-ID: <20070522112047.GS4705@kernel.dk>
References: <1179829525.12708.118.camel@chaos> <4652C640.3090806@garzik.org> <20070522112140.GB16308@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522112140.GB16308@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22 2007, Ingo Molnar wrote:
> 
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
> > >@@ -1709,12 +1710,11 @@ static int __init sjcd_init(void)
> > > 	printk(KERN_INFO "SJCD: Resetting: ");
> > > 	sjcd_send_cmd(SCMD_RESET);
> > > 	for (i = 1000; i > 0 && !sjcd_status_valid; --i) {
> > >-		unsigned long timer;
> > >-
> > > 		/*
> > > 		 * Wait 10ms approx.
> > > 		 */
> > >-		for (timer = jiffies; time_before_eq(jiffies, timer););
> > >+		msleep(10);
> > >+
> > 
> > I always worry when I see code like this, wondering if there is some 
> > arcane reason that I cannot fathom, that is being removed.  You gotta 
> > wonder how long it has been since this driver was used, by anybody.
> > 
> > Oh well, I cannot find fault with the patch, paranoia worries aside.
> 
> well, while i dont have that hardware, i found this by booting an 
> allyesconfig bzImage which runs the code above, which locks up without 
> this change. And then it booted fine with this change. So arcane issues 
> aside, it does visibly improve things ;-)

But if you looked at the driver, you'd see 2 other identical busy loops
in the very same function :-)

-- 
Jens Axboe

