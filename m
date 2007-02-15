Return-Path: <linux-kernel-owner+w=401wt.eu-S1161688AbXBOX5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161688AbXBOX5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161672AbXBOX5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:57:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39391 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161688AbXBOX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:57:20 -0500
Date: Fri, 16 Feb 2007 00:57:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       sfaibish <sfaibish@emc.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070215235716.GA14199@one.firstfloor.org>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <p73sld7f96t.fsf@bingen.suse.de> <Pine.LNX.4.61.0702152152460.19998@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702152152460.19998@ditec.inf.um.es>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Also many storage subsystems have some internal parallelism
> >in writing (e.g. a RAID can write on different disks in parallel for
> >a single partition) so i'm not sure your distinction is that useful.
> >
> But we are talking about a different case. What I have said is that if you 
> use two devices, one for the 'regular' file system and another one for the 
> log, DualFS is better in that case because it can use the log for reads. 
> Other journaling file systems can not do that.

Shadow paging based systems typically can, but we have no widely used
one on Linux (reiser4 would be probably the closest) 

> >If you stripe two disks with a standard fs versus use one of them
> >as metadata volume and the other as data volume with dualfs i would
> >expect the striped variant usually be faster because it will give
> >parallelism not only to data versus metadata, but also to all data
> >versus other data.
> >
> If you have a RAID system, both the data and meta-data devices of DualFS 
> can be stripped, and you get the same result. No problem for DualFS :)

Sure, but then you need four disks. And if your workloads happens 
to be much more data intensive than metadata intensive the 
stripped spindles assigned to metadata only will be more idle
than the ones doing data.

Stripping everything from the same pool has the potential
to adapt itself to any workload mix better.

I can see that you win for some specific workloads, but it is 
hard to see how you can win over a wide range of workloads
because of that.

> 
> >Also I would expect your design to be slow for metadata read intensive
> >workloads. E.g. have you tried to boot a root partition with dual fs?
> >That's a very important IO benchmark for desktop Linux systems.
> >
> I do not think so. The performance of DualFS is superb in meta-data read 
> intensive workloads . And it is also better than the performance of other 
> file system when reading a directory tree with several copies of the Linux 
> kernel source code (I showed those results on Tuesday at the LSF07 
> workshop)

PDFs available? 

Is that with running a LFS style cleaner inbetween or without?

I would be interested in a "install distro with installer ; boot afterwards
from it" type benchmark. Do you have something like this? 

-Andi
