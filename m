Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYEPIHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYEPIHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEPIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:07:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:52661 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYEPIHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:07:19 -0400
Subject: Re: [PATCH] x86: Get irq for hpet timer
From: Kevin Hao <kexin.hao@windriver.com>
To: Balaji Rao R <balajirrao@gmail.com>
Cc: venkatesh.pallipadi@intel.com, clemens@ladisch.de, bob.picco@hp.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <569c97d20805160053n8a5deceu25c8b37f02e02842@mail.gmail.com>
References: <1210917912.10881.1.camel@kevin-desktop>
	 <569c97d20805160053n8a5deceu25c8b37f02e02842@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 16:03:25 +0800
Message-Id: <1210925005.10881.12.camel@kevin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 08:05:46.0972 (UTC) FILETIME=[A597B9C0:01C8B72B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 13:23 +0530, Balaji Rao R wrote:
> On Fri, May 16, 2008 at 11:35 AM, Kevin Hao <kexin.hao@windriver.com> wrote:
> >
> > Hi,
> >
> > x86: get irq for hpet timer
> >
> > HPET timer's IRQ is 0 by default, so we have to select which irq
> > will be used for these timers. We wait to set the timer's irq until
> > we really turn on interrupt in order to reduce the chance of
> > conflicting with some legacy device.
> >
> Yes, this is alright. But  i've seen some machines where we have a
> valid IRQ in 'devp->hd_hdwirq' which you should not ignore. So, first
> check if it is zero and only then do a hpet_timer_get_irq.

Yes, I have checked that case in hpet_timer_get_irq function. See the
following code:

+       irq = devp->hd_hdwirq;


+       if (irq) {
+               if (request_irq(irq, hpet_interrupt, irq_flags,
+                               devp->hd_name, (void *)devp)) {
+                       printk(KERN_ERR "hpet: IRQ %d is not free\n",
irq);
+                       irq = 0;
+               }
+               return irq;
+       }

Is that right?

Thanks for your comments.

Best Regards,
Kevin

> 
> --
> warm regards
> 
> Balaji Rao
> NITK Surathkal
