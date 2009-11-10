Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZKJQrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZKJQrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZKJQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbZKJQrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:47:40 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
	<x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	<x49my2zh47n.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0911080901n6b855b0dle63f0151073ec2c6@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Nov 2009 11:47:30 -0500
In-Reply-To: <4e5e476b0911080901n6b855b0dle63f0151073ec2c6@mail.gmail.com>
	(Corrado Zoccolo's message of "Sun, 8 Nov 2009 18:01:50 +0100")
Message-ID: <x494op25ntp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Jeff, Jens,
> do you think we should try to do more auto-tuning of cfq parameters?
> Looking at those numbers for SANs, I think we are being suboptimal in
> some cases.
> E.g. sequential read throughput is lower than random read.

I investigated this further, and this was due to a problem in the
benchmark.  It was being run with only 500 samples for random I/O and
65536 samples for sequential.  After fixing this, we see random I/O is
slower than sequential, as expected.

> I also think that current slice_idle and slice_sync values are good
> for devices with 8ms seek time, but they are too high for non-NCQ
> flash devices, where "seek" penalty is under 1ms, and we still prefer
> idling.

Do you have numbers to back that up?  If not, throw a fio job file over
the fence and I'll test it on one such device.

> If we agree on this, should the measurement part (I'm thinking to
> measure things like seek time, throughput, etc...) be added to the
> common elevator code, or done inside cfq?

Well, if it's something that is of interest to others, than pushing it
up a layer makes sense.  If only CFQ is going to use it, keep it there.

Cheers,
Jeff
