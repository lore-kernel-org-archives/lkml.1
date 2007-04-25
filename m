Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXDYMW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXDYMW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXDYMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:22:26 -0400
Received: from mx2.go2.pl ([193.17.41.42]:45060 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965397AbXDYMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:22:25 -0400
Date: Wed, 25 Apr 2007 14:28:14 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070425122814.GF1613@ff.dom.local>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425122038.GE1613@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 02:20:38PM +0200, Jarek Poplawski wrote:
> 2 cents more...
... 
> On Tue, Apr 24, 2007 at 10:55:37PM +0400, Oleg Nesterov wrote:
> > +	do {
> > +		retry = 1;

Of course this'll be shorter:

		retry = 0;

> > +		spin_lock_irq(&cwq->lock);
> > +		/* CPU_DEAD in progress may change cwq */
> > +		if (likely(cwq == get_wq_data(work))) {
> > +			list_del_init(&work->entry);
> > +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> > +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> > +		}
> > +		spin_unlock_irq(&cwq->lock);
> > +	} while (unlikely(retry));
...

Jarek P.
