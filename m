Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYEPIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYEPIay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYEPIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:30:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:10144 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYEPIao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XojqL5CFDL8cxL9RwFHpdU2lF5JXPYWkyhiUr4PDTPCxCTwuVvGhO0hD43FLKeRq0ldRAfA+240jUEUAW9388JI5d0nkCVQRH+dxx4Kc6ON41NWJUNl2TWyAc661OYcjLjupAC5Y2skrjRpUXH9bOcIyJmHM9Tjd0xzYhjtLtcA=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Kevin Hao <kexin.hao@windriver.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
Date: Fri, 16 May 2008 14:00:32 +0530
User-Agent: KMail/1.9.9
Cc: venkatesh.pallipadi@intel.com, clemens@ladisch.de, bob.picco@hp.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <1210917912.10881.1.camel@kevin-desktop> <569c97d20805160053n8a5deceu25c8b37f02e02842@mail.gmail.com> <1210925005.10881.12.camel@kevin-desktop>
In-Reply-To: <1210925005.10881.12.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161400.33618.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 01:33:25 pm Kevin Hao wrote:
> On Fri, 2008-05-16 at 13:23 +0530, Balaji Rao R wrote:
> > On Fri, May 16, 2008 at 11:35 AM, Kevin Hao <kexin.hao@windriver.com> 
wrote:
> > > Hi,
> > >
> > > x86: get irq for hpet timer
> > >
> > > HPET timer's IRQ is 0 by default, so we have to select which irq
> > > will be used for these timers. We wait to set the timer's irq until
> > > we really turn on interrupt in order to reduce the chance of
> > > conflicting with some legacy device.
> >
> > Yes, this is alright. But  i've seen some machines where we have a
> > valid IRQ in 'devp->hd_hdwirq' which you should not ignore. So, first
> > check if it is zero and only then do a hpet_timer_get_irq.
>
> Yes, I have checked that case in hpet_timer_get_irq function. See the
> following code:
>
> +       irq = devp->hd_hdwirq;
>
>
> +       if (irq) {
> +               if (request_irq(irq, hpet_interrupt, irq_flags,
> +                               devp->hd_name, (void *)devp)) {
> +                       printk(KERN_ERR "hpet: IRQ %d is not free\n",
> irq);
> +                       irq = 0;
> +               }
> +               return irq;
> +       }
>
> Is that right?
>
Yes. You are right. Sorry for not going through the patch fully before making 
noise.

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
