Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZDMUMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZDMUMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDMUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:12:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZDMUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:12:17 -0400
Date: Mon, 13 Apr 2009 22:11:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
Message-ID: <20090413201155.GA17450@elte.hu>
References: <49E31931.5000506@cn.fujitsu.com> <20090413180054.GZ5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413180054.GZ5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Apr 13 2009, Li Zefan wrote:
> > Impact: allow ftrace-plugin blktrace to trace device-mapper devices
> > 
> > blktrace can't trace a single partition, so it makes no sense to
> > have one trace/ dir in each /sys/block/sda/sdaX. Move it to
> > /sys/block/sda/.
> > 
> > Thus we fix an issue reported by Ted, that ftrace-plugin 
> > blktrace can't be used to trace device-mapper devices.
> 
> Perhaps I never committed that patch, but it would be trivial to 
> do partition based blktrace tracing. It's also quite useful. So 
> please don't go changing things to make that harder to support, it 
> would be nicer to just add the (small) bits to support 
> per-partition tracing. It's basically just a start/stop sector 
> range, while some events are per-device and should just be 
> included always.

btw., per tracepoint filters could be used for that. That would 
allow multiple partitions to be traced at once.

blktrace user-space could make use of sector range filters straight 
away [ hm, Tom - do we have the <= comparison operator already, or 
is that still WIP? ] - but i think it's better to do this in a more 
integrated way: via the sysfs API, via /sys/block/sda/sda2/trace/.

So when a partition's trace entry is activated, it would 
auto-install a specific filter expression for sda, with the sector 
range of that partition. Or something like that. How does this 
sound?

	Ingo
