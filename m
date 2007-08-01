Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbXHASbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbXHASbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760248AbXHASbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:31:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:60756 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187AbXHASbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:31:40 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801181253.GA90@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185987663.12034.99.camel@twins>  <20070801181253.GA90@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:29:54 -0700
Message-Id: <1185992994.2636.142.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 22:12 +0400, Oleg Nesterov wrote:

> And I personally think it is not very useful, even if it was correct.
> You can create your own workqueue and change the priority of cwq->thread.

This change is more dynamic than than just setting a single priority ..
There was some other work going on around this, so it's not totally
clear what the benefits are ..

> > > @@ -168,7 +171,7 @@ int fastcall queue_work(struct workqueue
> > >  	int ret = 0, cpu = raw_smp_processor_id();
> > >  
> > >  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > > -		BUG_ON(!list_empty(&work->entry));
> > > +		BUG_ON(!plist_node_empty(&work->entry));
> > >  		__queue_work(wq_per_cpu(wq, cpu), work);
> > >  		ret = 1;
> 
> Side note, looks like you use some strange kernel. This raw_smp_processor_id()
> above is wrong.

As the topic suggests , it's a Real Time kernel .. I can give you a link
where to download it if you want.

Daniel

