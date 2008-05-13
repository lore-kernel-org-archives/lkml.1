Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbYEMNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbYEMNyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYEMNyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:54:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52555 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbYEMNyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:54:00 -0400
Subject: Re: performance "regression" in cfq compared to anticipatory, 
	deadline and noop
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matthew <jackdachef@gmail.com>
In-Reply-To: <20080513122021.GP16217@kernel.dk>
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
	 <1210514567.7827.62.camel@localhost>  <20080513122021.GP16217@kernel.dk>
Content-Type: text/plain
Date: Tue, 13 May 2008 15:51:04 +0200
Message-Id: <1210686664.1093.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 14:20 +0200, Jens Axboe wrote:
> On Sun, May 11 2008, Kasper Sandberg wrote:
> > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
> > > I've been experiencing this for a while also; an almost 50% regression
> > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
> > > more (eg default of 8) [1], which seems phenomenal.
<snip>
> > 
> > Thisd would appear to be quite a considerable performance difference.
> 
> Indeed, that is of course a bug. The initial mail here mentions this as
> a regression - which kernel was the last that worked ok?

I am afraid i cannot exactly tell you..

But i do have some additional information for you.

I have a server running with identical disk to mine, however, with an
older intel ahci controller..

This one gets 80mb/s with cfq, and 100mb/s with
anticipatory/deadline/noop with hdparm..

This server is running debian stable with a .18 kernel. I am sad to say
however, that i will be unable to do any testing on this box, since it
is a production server, and i can not shut it down.

haltek:~/blktrace# ./blktrace  /dev/sda
BLKTRACESETUP: Inappropriate ioctl for device
Failed to start trace on /dev/sda

However, on the box where you saw the previous numbers, i sure will be
able to provide you with the data you need.

i expect to get around to doing this this afternoon, or tonight at
~02:00
(im GMT+1).


> 
> If someone would send me a blktrace of such a slow run, that would be
> nice. Basically just do a blktrace /dev/sda (or whatever device) while
> doing the hdparm, preferably storing output files on a difference
> device. Then send the raw sda.blktrace.* files to me. Thanks!
> 

