Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZKQMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZKQMip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZKQMio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:38:44 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:48033 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZKQMin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:38:43 -0500
Subject: Re: [RFC] Block IO Controller V2 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <20091116221827.GL13235@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 07:38:47 -0500
Message-ID: <1258461527.2862.2.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 17:18 -0500, Vivek Goyal wrote:
> On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:
> 
> [..]
> > ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> > 
> > The next thing to look at is to see what the "penalty" is for the
> > additional code: see how much bandwidth we lose for the capability
> > added. Here we see the sum of the system's throughput for the various
> > tests:
> > 
> > ---- ---- - ----------- ----------- ----------- ----------- 
> > Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> > ---- ---- - ----------- ----------- ----------- ----------- 
> >  rnd   rd 2        17.3        17.1         9.4         9.1 
> >  rnd   rd 4        27.1        27.1         8.1         8.2 
> >  rnd   rd 8        37.1        37.1         6.8         7.1 
> > 
> 
> Hi Alan,
> 
> This seems to be the most notable result in terms of performance degradation.
> 
> I ran two random readers on a locally attached SATA disk. There in fact
> I gain in terms of performance because we perform less number of seeks
> now as we allocate a continous slice to one group and then move onto
> next group.
> 
> But in your setup it looks like there is a striped set of disks and seek
> cost is less and waiting per group for sync-noidle workload is hurting
> instead.


That is correct - there are 4 back-end buses on an MSA1000, and each LUN
that is exported is constructed from 1 drive from each bus (hardware
striped RAID). [There is _no_ SW RAID involved.]


> 
> One simple way to test that would be to set slice_idle=0 so that CFQ does
> not try to do any idling at all. Can you please re-run above test. This
> will help in figuring out whether above performance regression is coming
> from idling on sync-noidle workload group per cgroup or not.

I'll put that in the queue - first I'm going to re-run w/ synchronous
direct I/O for the writes. I'm also going to pair this down to just
doing 2-processes per disk runs (to simplify results & speed up tests).
Once we get that working better, I can expand things back out.

> 
> Above numbers are in what units?

These are in MiB/second (derived from the FIO output).

> 
> Thanks
> Vivek



