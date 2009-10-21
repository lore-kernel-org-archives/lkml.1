Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZJUVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZJUVqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZJUVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:46:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41171 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZJUVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IR4PfROzNsH3M+bN3htc0yZZyleOrYuUqNW1wpiAZ7SXpORWFIaOYAAa4xFTIBYCrK
         xcyqqIbYYkRov6FjlHJSDRaGmke0ar8hoX3rEseFK4EJ2/7e0zflqI71kNqc8XCkdvPr
         2N54PL74RIK/4zF7+wI4nwQJ2qAProxuDMD08=
Date: Wed, 21 Oct 2009 23:39:47 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091021213947.GA12202@ami.dom.local>
References: <4AD31213.6020006@imap.cc>
 <20091015114052.GA9870@ff.dom.local>
 <4AD76184.6030900@gmail.com>
 <4ADF5710.4030505@imap.cc>
 <20091021211906.GA11401@ami.dom.local>
 <1256160330.12174.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256160330.12174.2.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 06:25:30AM +0900, Johannes Berg wrote:
> On Wed, 2009-10-21 at 23:19 +0200, Jarek Poplawski wrote:
...
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2728,7 +2728,7 @@ void __napi_schedule(struct napi_struct *n)
> >  
> >  	local_irq_save(flags);
> >  	list_add_tail(&n->poll_list, &__get_cpu_var(softnet_data).poll_list);
> > -	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > +	raise_softirq_irqoff(NET_RX_SOFTIRQ);
> 
> This still doesn't make any sense.
> 
> There may or may not be a lot of code that assumes that everything else
> is run with other tasklets disabled, and that it cannot be interrupted
> by a tasklet and thus create a race.
> 
> Can you prove that is not the case, across the entire networking layer?

I'm not sure I can understand your question. This patch is mainly to
avoid using netif_rx()/netif_rx_ni() pair as a test of proper process
context handling; IMHO there're better tools for this (lockdep,
WARN_ON's).

Jarek P.
