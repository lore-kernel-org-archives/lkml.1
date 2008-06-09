Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbYFIPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbYFIPBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYFIPBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:01:05 -0400
Received: from server515d.exghost.com ([72.32.253.78]:4991 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378AbYFIPBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:01:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Mon, 9 Jun 2008 09:56:14 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CA536EF@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <20080609142717.GB24950@rap.rap.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Thread-Index: AcjKPO3cniFd2lezSOGBLh6Tu+5cDgAAFrqA
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan> <e9c3a7c20806071846w60b74aeegdf3e39afb36b5d9a@mail.gmail.com> <8CA981CB5C2B4D6-E68-18E2@MBLK-M14.sysops.aol.com> <A20315AE59B5C34585629E258D76A97CA535E9@34093-C3-EVS3.exchange.rackspace.com> <20080609142717.GB24950@rap.rap.dk>
From: "David Lethe" <david@santools.com>
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: <thomas62186218@aol.com>, <dan.j.williams@gmail.com>,
       <jpiszcz@lucidpixels.com>, <linux-kernel@vger.kernel.org>,
       <linux-raid@vger.kernel.org>, <xfs@oss.sgi.com>, <ap@solarrain.com>
X-OriginalArrivalTime: 09 Jun 2008 15:00:58.0795 (UTC) FILETIME=[A01C3FB0:01C8CA41]
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Primary: david@santools.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: david@santools.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.49.5
X-Note-Reverse-DNS: fe1.exchange.rackspace.com
X-Note-WHTLIST: david@santools.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: 81 82 148 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Keld Jørn Simonsen [mailto:keld@dkuug.dk] 
Sent: Monday, June 09, 2008 9:27 AM
To: David Lethe
Cc: thomas62186218@aol.com; dan.j.williams@gmail.com; jpiszcz@lucidpixels.com; linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org; xfs@oss.sgi.com; ap@solarrain.com
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors

On Mon, Jun 09, 2008 at 08:41:18AM -0500, David Lethe wrote:
> For faster random I/O:
>  * Decrease chunk size
>  * Migrate files that have higher random I/O to a RAID1 set, using disks
> with the lowest access time/latency
>  * If possible, use the /dev/shm file system 
>  * Determine I/O size of apps that produce most of the random I/O, and
> make sure that md+filesystem matches. If most random I/O is 32KB, then
> don't waste bandwidth by making md read 256KB at a time, or making it
> read 2x16KB I/Os. Also don't build md sets like 4-drive RAID5, (Do a
> 5-drive RAID5 set), because non-parity data isn't a multiple of 2. A
> 10-drive RAID5 set with heavy random I/O is also profoundly wrong
> because you are just removing the opportunity to have all of those heads
> processing random I/O. 
>  * If you only have one partition on a md set, then partition it into a
> few file systems. This may provide greater opportunity for caching I/Os.
>  * Experiment with different file systems, and optimize accordingly.  
>  * Turn of journaling, or at least move journals to RAID1 devices.
>  * Add RAM and try to increase buffer cache in attempt to improve cache
> hit percentage (this works up to a point)
>  * Buy a small SSD and migrate files that get pounded with random I/O to
> that device. (Make sure you don't get a flash SSD, but a DRAM based SSD
> that satisfies random I/O in nanoseconds instead of millisecs). They are
> expensive, but the appropriate device.  This is how companies such as
> Google & Ebay manage to get things done. 
> The biggest thing to remember about random I/O, is that they are
> expensive, so just step back and think about ways to minimize the I/O
> requests to disk in the first place, and/or to spread the I/O across
> multiple raidsets that can work independently to satisfy your load.  All
> suggestions above will not work for everybody. You must understand the
> nature of the bottleneck. 


For faster random IO I would suggest to use raid10,f2 for the random
reading, it performs like raid0, something like more than double the
speed of a normal single-drive file system. For random writes raid10,f2
performs like most other mirrorred raids, given that data needs to be
written twice.

Try and see if you can gat any HW raids to match that performance.

best regards
keld

--------------------------------------------------------------------------------
Keld:
That is counter-intuitive. The issue is random IOPs, not throughput. I do not 
understand how a RAID10 would provide more IOs per sec than RAID1. Or, since
you are using RAID10, then how could RAID10 serve more random I/Os then a pair
of RAID1 filesystems?  RAID0 dictates that each disk will supply half 
of the data you want per application I/O request. At least with RAID1, then each
disk can get all the data you want with a single request, and dual-porting/load balancing 
will allow both disks to work independently of each other on reads so the disk with
the least amount of load at any time can work on the request. That is why RAID1 can be
faster than JBOD.

Granted writes are handled differently, but with any RAID0 implementation you still have to write
Half of the data to each disk requiring 2 I/Os + journaling & housekeeping.


David


