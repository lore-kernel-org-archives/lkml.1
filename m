Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYJMIrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYJMIrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYJMIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:47:17 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:37533 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYJMIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:47:16 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: benh@kernel.crashing.org
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks
Date: Mon, 13 Oct 2008 10:47:12 +0200
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200806031444.21945.borntraeger@de.ibm.com> <200810130951.31733.borntraeger@de.ibm.com> <1223886972.8157.241.camel@pasglop>
In-Reply-To: <1223886972.8157.241.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131047.12748.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. Oktober 2008 schrieb Benjamin Herrenschmidt:
> 
> >  	if (--hp->count == 0) {
> > -		if (hp->ops->notifier_del)
> > -			hp->ops->notifier_del(hp, hp->data);
> > -
> >  		/* We are done with the tty pointer now. */
> >  		hp->tty = NULL;
> >  		spin_unlock_irqrestore(&hp->lock, flags);
> >  
> > +		if (hp->ops->notifier_del)
> > +			hp->ops->notifier_del(hp, hp->data);
> > +
> 
> I will try. Of course the risk here is that the interrupt happens
> after we set hp->tty to NULL, so we probably need to check within the
> interrupt handler for a NULL tty. I haven't checked if that's the case
> (I'm not in front of the code right now).

Even the old code (without my patch) was setting hp->tty to NULL before doing 
the irq_free, so that should be ok.

Christian
