Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXFTJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXFTJoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXFTJnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:43:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXFTJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:43:51 -0400
Subject: Re: Change in default vm_dirty_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20070620092058.GP18863@kernel.dk>
References: <1182201271.4883.22.camel@localhost.localdomain>
	 <20070618164711.9de1c38e.akpm@linux-foundation.org>
	 <20070620042434.GC12096@redhat.com>
	 <20070619214407.dfff0ca6.akpm@linux-foundation.org>
	 <1182328536.21117.24.camel@twins>
	 <20070620015826.03f1d71a.akpm@linux-foundation.org>
	 <20070620091404.GO18863@kernel.dk> <1182331182.21117.39.camel@twins>
	 <20070620092058.GP18863@kernel.dk>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 11:43:41 +0200
Message-Id: <1182332621.21117.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 11:20 +0200, Jens Axboe wrote:
> On Wed, Jun 20 2007, Peter Zijlstra wrote:
> > On Wed, 2007-06-20 at 11:14 +0200, Jens Axboe wrote:
> > > On Wed, Jun 20 2007, Andrew Morton wrote:
> > > > Perhaps our queues are too long - if the VFS _does_ back off, it'll take
> > > > some time for that to have an effect.
> > > > 
> > > > Perhaps the fact that the queue size knows nothing about the _size_ of the
> > > > requests in the queue is a problem.
> > > 
> > > It's complicated, the size may not matter a lot. 128 sequential 512kb IO
> > > may complete faster than 128 random 4kb IO's.
> > 
> > Yes, is there any way a queue could be limited to a certain amount of
> > 'completion time' ?
> 
> Not easily, we'd need some sort of disk profile for that to be remotely
> reliable.

Yes, I see the problem, benching the device is hard; you don't want it
to do it each time, nor for it to take too long. Also, write performance
might be destructive, also not quite wanted :-/

/me sees this libtune doom on the horizon again.

Something adaptive would be best, something that inserts barriers and
measures the time to complete and then solves the read speed, write
speed and seek latency. All during normal operation.

That would entail storing a bunch of these sample points, solve the
equation for sets of 3, and (time-) average the results.. ugh



