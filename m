Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbXHHLLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbXHHLLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXHHLLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:11:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:50181 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXHHLLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sDakiBnBoppbW8KK60APQSBG0IOTsK2vi3uLKIEBBt5ap0my7wzC4L1PcfTKftwnBup8D2eKoZVhRA5ZqnDei9luz6gs9VLp0K4IXMwu/+qpaQYzSBMO/OmYpy7tIdmktaKiph9HI/whzDT/cy3g6SZNB6+pG0QlZNef6iIq9Mo=
Message-ID: <4bacf17f0708080411r3a7c3b78je3e1189d04a65f38@mail.gmail.com>
Date: Wed, 8 Aug 2007 13:11:20 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070807125518.GA4669@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726091254.GA8063@elte.hu>
	 <20070731132037.GC1046@ff.dom.local>
	 <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com>
	 <20070806070300.GA4509@elte.hu>
	 <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com>
	 <20070807082321.GB2120@ff.dom.local>
	 <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com>
	 <20070807095246.GB3223@ff.dom.local>
	 <20070807121339.GA3946@ff.dom.local>
	 <20070807125518.GA4669@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/7, Jarek Poplawski <jarkao2@o2.pl>:
> And here is one more patch to test the same idea (chip->retrigger()).
> Let's try i386 way! (I hope I will not be arrested for this...)
> (Should be tested without any previous patches.)
>
> Jarek P.
>
> PS: as above
>
> ---
>
> diff -Nurp 2.6.22.1-/arch/x86_64/kernel/io_apic.c 2.6.22.1/arch/x86_64/kernel/io_apic.c
> --- 2.6.22.1-/arch/x86_64/kernel/io_apic.c      2007-07-09 01:32:17.000000000 +0200
> +++ 2.6.22.1/arch/x86_64/kernel/io_apic.c       2007-08-07 14:37:45.000000000 +0200
> @@ -1311,15 +1311,8 @@ static unsigned int startup_ioapic_irq(u
>  static int ioapic_retrigger_irq(unsigned int irq)
>  {
>         struct irq_cfg *cfg = &irq_cfg[irq];
> -       cpumask_t mask;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&vector_lock, flags);
> -       cpus_clear(mask);
> -       cpu_set(first_cpu(cfg->domain), mask);
>
> -       send_IPI_mask(mask, cfg->vector);
> -       spin_unlock_irqrestore(&vector_lock, flags);
> +       send_IPI_self(cfg->vector);
>
>         return 1;
>  }
>
Network card timed out with this patch.

Marcin
