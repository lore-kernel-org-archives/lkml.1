Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbXEPUHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbXEPUHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763263AbXEPUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:07:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763229AbXEPUHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:07:01 -0400
Date: Wed, 16 May 2007 13:04:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-Id: <20070516130413.1fd391bf.akpm@linux-foundation.org>
In-Reply-To: <20070516195359.GE26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com>
	<464B2AC2.10206@redhat.com>
	<20070516171156.GY26766@think.oraclecorp.com>
	<20070516112515.b6f247b2.akpm@linux-foundation.org>
	<20070516191339.GA26766@think.oraclecorp.com>
	<20070516123342.714a11d8.akpm@linux-foundation.org>
	<20070516195359.GE26766@think.oraclecorp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 15:53:59 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> > 
> > Should be: it uses first-fit.
> > 
> > >  Looks like ext3 is just walking a list of
> > > bh/jh, maybe we can just sort the silly thing?
> > 
> > The IO scheduler is supposed to do that.
> > 
> > But I don't know what's causing this.
> 
> I had high hopes of blaming cfq, but deadline gives the same results:
> 
> create dir kernel-0 222MB in 5.38 seconds (41.33 MB/s)
> ... [ ~30MB/s here ] ...
> create dir kernel-7 222MB in 8.11 seconds (27.42 MB/s)
> create dir kernel-8 222MB in 18.39 seconds (12.09 MB/s)
> create dir kernel-9 222MB in 6.91 seconds (32.18 MB/s)
> create dir kernel-10 222MB in 24.32 seconds (9.14 MB/s)
> create dir kernel-11 222MB in 12.06 seconds (18.44 MB/s)
> create dir kernel-12 222MB in 10.95 seconds (20.31 MB/s)
> 
> The good news is that if you let it run long enough, the times
> stabilize.  The bad news is:
> 
> create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)

well hang on.  Doesn't this just mean that the first few runs were writing
into pagecache and the later ones were blocking due to dirty-memory limits?

Or do you have a sync in there?

> echo 2048 > /sys/block/..../nr_requests didn't do it either.
> 
> I guess I'll have systemtap tell me more about the log flushing.
