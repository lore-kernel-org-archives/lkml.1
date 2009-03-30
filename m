Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbZC3Rvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbZC3Rvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZC3RvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:51:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39286 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZC3RvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:51:24 -0400
Date: Mon, 30 Mar 2009 19:51:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage
	device writeback cache flushes
Message-ID: <20090330175121.GW5178@kernel.dk>
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp> <200903301714.13174.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903301714.13174.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Bartlomiej Zolnierkiewicz wrote:
> On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> > Add a sysfs knob to disable storage device writeback cache flushes.
> 
> The horde of casual desktop users (with me included) would probably prefer
> having two settings -- one for filesystem barriers and one for fsync().
> 
> IOW I prefer higher performance at the cost of risking losing few last
> seconds/minutes of work in case of crash / powerfailure but I would still
> like to have the filesystem in the consistent state after such accident.

The knob is meant to control whether we really need to send a flush to
the device or not, so it's an orthogonal issue to what you are talking
about. For battery backed caches, we never need to flush. This knob is
useful IFF we have devices with write back caches that STILL do a cache
flush.

As such, I'd also prefer waiting with adding such a knob until such a
device has actually be observed. No point in adding something just in
case it may exist. And even then, it's probably even better handled in
the driver.

-- 
Jens Axboe

