Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZFWLob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZFWLob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbZFWLoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:44:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZFWLoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:44:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: merging the per-bdi writeback patchset
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org
In-Reply-To: <20090623112849.GA31415@kernel.dk>
References: <20090623201225.223F.A69D9226@jp.fujitsu.com> <20090623112849.GA31415@kernel.dk>
Message-Id: <20090623204119.2245.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Jun 2009 20:44:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Can you please make reproduce program and post mesurement result?
> > > > I hope to mesure the same program on my box.
> > > 
> > > For which issue? Lumpy writeout can often be observed just by doing
> > > buffered writes to a bunch of files.
> > 
> > Yes, I know current behavior is not perfectly optimal.
> > but I haven't seen it cause serious issue.
> > 
> > Then, I guess you have big degression workload, yes? if so, I hope to
> > see it.
> 
> Not really, I was just interested in making it more optimal. I work from
> various fio job files, one case that is sped up greatly is doing random
> writes with mmap to an otherwise buffered file. pdflush is both lumpy
> and a lot slower there, even with many pdflush threads active. Looking
> at disk utilization, pdflush doesn't manage more than ~80% for that. The
> per-bdi writeback is completely smooth and gets about as close to 100%
> utilization as possible (around ~98% there). And this is just one 1
> disk, the per-bdi writeback scales nicely upwards. pdflush falls flat.
> 
> And then there are lots of cases where the performance is the same. For
> many workloads, pdflush isn't really very active.
> 
> > > > Plus, Can you please write more vervose patch description? your patch is a
> > > > bit harder review.
> > > 
> > > OK, I can probably improve on that. Do you mean the general description
> > > of the patchset, or some of the individual patches?
> > 
> > Hopefully both. honestly I haven't understand your main worryed issue.
> 
> Does the above help? It's all about making the writeback more
> consistent. So getting rid of the lumpy writeback and eliminating the
> pdflush starvation were the prime motivators.

ok, thanks.
I try to review your patch series without any bias later.



