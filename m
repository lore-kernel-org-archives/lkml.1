Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXC2RxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXC2RxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXC2RxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:53:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXC2RxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:53:12 -0400
Date: Thu, 29 Mar 2007 19:51:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Message-ID: <20070329175117.GA5521@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <460BBD1B.4040308@ru.mvista.com> <200703291531.18253.maximlevitsky@gmail.com> <200703291546.48996.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw, what about arch/x86_64/kernel/hpet.c?

at least wrt. suspend/resume it should be fine, because in 
arch/x86_64/kernel/time.c it does this upon resume:

 static int timer_resume(struct sys_device *dev)
 {
         if (hpet_address)
                 hpet_reenable();
         else
                 i8254_timer_resume();

[ barring the issue that mixing two pieces of hardware like this in a 
  single resume function is wrong - all timer hardware should be 
  separated like we did it for i386. I've got 64-bit clockevents code in 
  -rt which does this separation. ]

> That thing seems totally broken. Lookie here:
> 
>   arch/x86_64/kernel/hpet.c:irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
>   drivers/char/rtc.c:extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
> 
> anybody see a problem? The x86-64 version doesn't seem to be very well 
> maintained. Is there some fundamental reason why this file isn't 
> shared across architectures?

there's no fundamental reason. x86_64 COW-ed hpet_timer.c and 
time_hpet.c years ago and drifted off into different areas.
They should be unified: more power to arch/x86/ ;-)

	Ingo
