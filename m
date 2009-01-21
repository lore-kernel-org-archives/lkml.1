Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZAUGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZAUGSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 01:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZAUGSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 01:18:04 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:62470 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZAUGSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R/08eEwsEHiZsQNECJAaGTkgT9lJkf3NLrUWNG4YkJSBr+rLKCp5ll/XYjfADboBr6
         nKVt/PQqn7gYfiliCZbLoRTz4JR/gGgHhO+OpINNNYh+gHvMGkj7LUZ/zmsCrotIgXE/
         SQ3XuZ8OGCdEGFi00D/QRsS3RLj9i/sfEJ2C4=
Subject: Re: [ltt-dev] [RFC PATCH] block: Fix bio merge induced high I/O
 latency
From: Ben Gamari <bgamari@gmail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       ltt-dev@lists.casi.polymtl.ca,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090121045447.GA18334@Krystal>
References: <20090117162657.GA31965@Krystal>
	 <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal>
	 <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal>
	 <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk>
	 <20090120232748.GA10605@Krystal> <20090121002507.GA12616@Krystal>
	 <720e76b80901202038p1e1f929ci56e9f35c5a629c88@mail.gmail.com>
	 <20090121045447.GA18334@Krystal>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 01:17:45 -0500
Message-Id: <1232518666.3695.68.camel@mercury.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 23:54 -0500, Mathieu Desnoyers wrote:
> * Ben Gamari (bgamari@gmail.com) wrote:
> > On Tue, Jan 20, 2009 at 7:25 PM, Mathieu Desnoyers
> > <mathieu.desnoyers@polymtl.ca> wrote:
> > > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > >
> > > As a side-note : I'd like to have my results confirmed by others.
> > 
> > Well, I think the (fixed) patch did help to some degree (I haven't
> > done fio benchmarks to compare against yet). Unfortunately, the I/O
> > wait time problem still remains. I have been waiting 3 minutes now for
> > evolution to start with 88% I/O wait time yet no visible signs of
> > progress. I've confirmed I'm using the CFQ scheduler, so that's not
> > the problem.
> > 
> 
> Did you also 
> 
> echo 1 > /sys/block/sd{a,b}/device/queue_depth
I have been using this in some of my measurements (this is recorded, of
course).

> echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
> echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum
I haven't been doing this although I will collect a data set with these
parameters set. It would be to compare the effect of this to the default
configuration.

> 
> (replacing sd{a,b} with your actual drives) ?
> 
> It seems to have been part of the factors that helped (along with the
> patch).
> 
> And hopefully you don't have a recent Seagate hard drive like me ? :-)
Thankfully, no.

> 
> So you test case is :
> - start a large dd with 1M block size
> - time evolution
> 
I've been using evolution to get a rough idea of the performance of the
configurations but not as a benchmark per se. I have some pretty
good-sized maildirs, so launching evolution for the first time can be
quite a task, IO-wise. Also, switching between folders used to be quite
time consuming. It seems like the patch did help a bit on this front
though.

For a quantitative benchmark I've been using the fio job that you posted
earlier. I've been collecting results and should have a pretty good data
set soon.

I'll send out a compilation of all the data I've collected as soon as
I've finished.

- Ben


