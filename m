Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYDQHK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYDQHK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYDQHKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:10:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21428 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYDQHKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:10:15 -0400
Date: Thu, 17 Apr 2008 09:10:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417071012.GP12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4806EACB.7040408@unimore.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Paolo Valente wrote:
> Pavel Machek ha scritto:
> >
> >>In the first type of tests, to achieve a higher throughput than CFQ
> >>(with the default 100 ms time slice), the maximum budget for BFQ
> >>had to be set to at least 4k sectors.  Using the same value for the
> >>    
> >
> >Hmm, 4k sectors is ~40 seconds worst case, no? That's quite long...
> >  
> Actually, in the worst case among our tests, the aggregate throughput 
> with 4k sectors was ~ 20 MB/s, hence the time for 4k sectors ~ 4k * 512 
> / 20M = 100 ms.

That's not worse case, it is pretty close to BEST case. Worst case is 4k
of sectors, with each being a 512b IO and causing a full stroke seek.
For that type of workload, even a modern sata hard drive will be doing
500kb/sec or less. That's rougly a thousand sectors per seconds, so ~4
seconds worst case for 4k sectors.

-- 
Jens Axboe

