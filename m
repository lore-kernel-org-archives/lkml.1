Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYJMIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYJMIoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYJMIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:44:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:45445 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbYJMIoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:44:00 -0400
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions
	with callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200810130951.31733.borntraeger@de.ibm.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
	 <200806031445.22561.borntraeger@de.ibm.com>
	 <1223875013.8157.230.camel@pasglop>
	 <200810130951.31733.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 19:36:12 +1100
Message-Id: <1223886972.8157.241.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  	if (--hp->count == 0) {
> -		if (hp->ops->notifier_del)
> -			hp->ops->notifier_del(hp, hp->data);
> -
>  		/* We are done with the tty pointer now. */
>  		hp->tty = NULL;
>  		spin_unlock_irqrestore(&hp->lock, flags);
>  
> +		if (hp->ops->notifier_del)
> +			hp->ops->notifier_del(hp, hp->data);
> +

I will try. Of course the risk here is that the interrupt happens
after we set hp->tty to NULL, so we probably need to check within the
interrupt handler for a NULL tty. I haven't checked if that's the case
(I'm not in front of the code right now).

Ben.


