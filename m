Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbYDQI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbYDQI5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYDQI5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:57:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2945 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYDQI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:57:04 -0400
Date: Thu, 17 Apr 2008 10:57:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paolo Valente <paolo.valente@unimore.it>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417085658.GW12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <20080417084815.GA31835@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417084815.GA31835@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Pavel Machek wrote:
> > On Thu, Apr 17 2008, Paolo Valente wrote:
> > > Pavel Machek ha scritto:
> > > >
> > > >>In the first type of tests, to achieve a higher throughput than CFQ
> > > >>(with the default 100 ms time slice), the maximum budget for BFQ
> > > >>had to be set to at least 4k sectors.  Using the same value for the
> > > >>    
> > > >
> > > >Hmm, 4k sectors is ~40 seconds worst case, no? That's quite long...
> > > >  
> > > Actually, in the worst case among our tests, the aggregate throughput 
> > > with 4k sectors was ~ 20 MB/s, hence the time for 4k sectors ~ 4k * 512 
> > > / 20M = 100 ms.
> > 
> > That's not worse case, it is pretty close to BEST case. Worst case is 4k
> > of sectors, with each being a 512b IO and causing a full stroke seek.
> > For that type of workload, even a modern sata hard drive will be doing
> > 500kb/sec or less. That's rougly a thousand sectors per seconds, so ~4
> > seconds worst case for 4k sectors.
> 
> One seek is still 10msec on modern drive, right? So 4k seeks =
> 40seconds, no? 4seconds would correspond to 1msec per seek, which
> seems low.

I actually meant 4k ios, not 512b at that isn't really realistic. With
512b full device seeks, you are looking at probably 30kb/sec on a normal
7200rpm drive and that would be around a minute worst case time. The 4kb
number of 500kb/sec may even be a bit too high, doing a quick test here
shows a little less than 300kb/sec on this drive. So more than 4 seconds
still, around 7-8s or so.

> writes with O_SYNC could force full seek on each request, right?

Writes generally work somewhat better due to caching, but doing O_DIRECT
512 byte reads all over the drive would exhibit worst case behaviour
easily.

-- 
Jens Axboe

