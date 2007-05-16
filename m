Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbXEPUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbXEPUQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXEPUQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:16:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34332 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbXEPUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:16:40 -0400
Date: Wed, 16 May 2007 16:14:14 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070516201414.GF26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com> <464B2AC2.10206@redhat.com> <20070516171156.GY26766@think.oraclecorp.com> <20070516112515.b6f247b2.akpm@linux-foundation.org> <20070516191339.GA26766@think.oraclecorp.com> <20070516123342.714a11d8.akpm@linux-foundation.org> <20070516195359.GE26766@think.oraclecorp.com> <20070516130413.1fd391bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516130413.1fd391bf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
> > The good news is that if you let it run long enough, the times
> > stabilize.  The bad news is:
> > 
> > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
> 
> well hang on.  Doesn't this just mean that the first few runs were writing
> into pagecache and the later ones were blocking due to dirty-memory limits?
> 
> Or do you have a sync in there?
> 
There's no sync,  but if you watch vmstat you can clearly see the log
flushes, even when the overall create times are 11MB/s.  vmstat goes
30MB/s -> 4MB/s or less, then back up to 30MB/s.

On the same box, my shiny new FS writes at 30MB/s the whole time.  For
this part of the benchmark, I think we should all be getting the same
numbers.

-chris

