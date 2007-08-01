Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXHAHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXHAHYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXHAHYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:24:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:27121 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbXHAHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mU5/Sq4mXpdSucZB1+RP3yHPjV0XIRj/SzhmRPbvvxBvpKQHbgOE6qjHOyG7k3YPMhKacfR/qMKIQqg8ixM7+NpePDCEiCLKLt7NJx8aSM/bRoKM03+7tptgqULTxq3CiMc5VoDcLrbyRw0pDbgZ2Ef2OmauEWMi0gznPCJEg7c=
Message-ID: <4bacf17f0708010024r3abc196dv4d6924e314536b17@mail.gmail.com>
Date: Wed, 1 Aug 2007 09:24:01 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070730084925.GA12695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	 <1185322771.4175.102.camel@chaos>
	 <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
	 <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos>
	 <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local>
	 <20070726091254.GA8063@elte.hu>
	 <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
	 <20070730084925.GA12695@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/30, Ingo Molnar <mingo@elte.hu>:
> (..)
> does the patch below fix those timeouts? It tests the theory whether any
> POST latency could expose this problem.
>
>         Ingo
>
> Index: linux/drivers/net/lib8390.c
> ===================================================================
> --- linux.orig/drivers/net/lib8390.c
> +++ linux/drivers/net/lib8390.c
> @@ -375,6 +375,8 @@ static int ei_start_xmit(struct sk_buff
>         /* Turn 8390 interrupts back on. */
>         ei_local->irqlock = 0;
>         ei_outb_p(ENISR_ALL, e8390_base + EN0_IMR);
> +       /* force POST: */
> +       ei_inb_p(e8390_base + EN0_IMR);
>
>         spin_unlock(&ei_local->page_lock);
>         enable_irq_lockdep_irqrestore(dev->irq, &flags);
>

Bad news. It doesn't fix the problem.

Marcin
