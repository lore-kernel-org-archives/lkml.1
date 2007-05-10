Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXEJO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXEJO0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXEJO0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:26:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41390 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbXEJO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:26:44 -0400
Date: Thu, 10 May 2007 15:29:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Message-ID: <20070510152957.5c1ddec9@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
	<20070509064923.GO4163@kernel.dk>
	<Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:17:57 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On May 9 2007 08:49, Jens Axboe wrote:
> >On Tue, May 08 2007, Andrew Morton wrote:
> >> > +#define bio_list_for_each(bio, bl) \
> >> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> >> > +	     bio = bio->bi_next)
> >> > +
> >
> >Besides, manual prefetching is very rarely a win. I dabbled with some
> >benchmarks a few weeks back (with the doubly linked lists), and in most
> >cases it was actually a loss. So I'd vote for just removing the
> >prefetch() above.
> 
> So is the prefetching in the basic ADTs (e.g. linux/list.h) a loss too?

Depends on the box it seems. On the newest systems the processor
prefetching seems to be very much smarter. On a "classic" AMD Athlon the
prefetching made the scheduler about 1.5% faster...

Alan
