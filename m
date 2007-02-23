Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXBWMxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXBWMxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXBWMxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:53:00 -0500
Received: from brick.kernel.dk ([62.242.22.158]:12556 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbXBWMw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:52:59 -0500
Date: Fri, 23 Feb 2007 13:52:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070223125247.GO5737@kernel.dk>
References: <20070221211355.GA7302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21 2007, Ingo Molnar wrote:
> this is the v3 release of the syslet/threadlet subsystem:
> 
>    http://redhat.com/~mingo/syslet-patches/

[snip]

Ingo, some testing of the experimental syslet queueing stuff, in the
syslet-testing branch of fio.

Fio job file:

[global]
bs=8k
size=1g
direct=0
ioengine=syslet-rw
iodepth=32
rw=read

[file]
filename=/ramfs/testfile

Only changes between runs was changing ioengine and iodepth as indicated
in the table below.

Results:

Engine          Depth           Bw (MiB/sec)
--------------------------------------------
libaio            1             441
syslet            1             574
sync              1             589
libaio           32             613
syslet           32             681

Results are stable to within +/- 1MiB/sec. So you can see that syslet
are still a bit slower than sync for depth 1, but beats the pants off
libaio for equal depths. Note that this is buffered IO, I'll be out for
the weekend, but I'll hack some direct IO testing up next week to
compare "real" queuing.

Just a quick microbenchmark to gauge current overhead...

-- 
Jens Axboe

