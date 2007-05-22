Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXEVLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXEVLWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXEVLWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:22:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748AbXEVLWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:22:07 -0400
Date: Tue, 22 May 2007 13:21:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
Message-ID: <20070522112140.GB16308@elte.hu>
References: <1179829525.12708.118.camel@chaos> <4652C640.3090806@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4652C640.3090806@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> >@@ -1709,12 +1710,11 @@ static int __init sjcd_init(void)
> > 	printk(KERN_INFO "SJCD: Resetting: ");
> > 	sjcd_send_cmd(SCMD_RESET);
> > 	for (i = 1000; i > 0 && !sjcd_status_valid; --i) {
> >-		unsigned long timer;
> >-
> > 		/*
> > 		 * Wait 10ms approx.
> > 		 */
> >-		for (timer = jiffies; time_before_eq(jiffies, timer););
> >+		msleep(10);
> >+
> 
> I always worry when I see code like this, wondering if there is some 
> arcane reason that I cannot fathom, that is being removed.  You gotta 
> wonder how long it has been since this driver was used, by anybody.
> 
> Oh well, I cannot find fault with the patch, paranoia worries aside.

well, while i dont have that hardware, i found this by booting an 
allyesconfig bzImage which runs the code above, which locks up without 
this change. And then it booted fine with this change. So arcane issues 
aside, it does visibly improve things ;-)

	Ingo
