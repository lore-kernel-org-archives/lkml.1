Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbZC3WCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbZC3WCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZC3WCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:02:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45365 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZC3WCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:02:35 -0400
Message-ID: <49D14137.6060203@garzik.org>
Date: Mon, 30 Mar 2009 18:01:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
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
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <20090330175953.GY5178@kernel.dk> <49D118E5.4060209@garzik.org> <200903302256.17738.bzolnier@gmail.com>
In-Reply-To: <200903302256.17738.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> calling fsync() after every mail fetched.  Adding mandatory cache flush
> to it only makes things worse (again looking from performance POV).
> 
> BTW in Linux world we never made any guarantees for fsync() on devices
> using write caching:

Quite true, but I've always thought that was trading away correctness 
for performance...  at a critical juncture where a consistency 
checkpoint was explicitly requested by the app.

My ideal would probably be blkdev cache flushing by default on fsync(2), 
with a block layer "desktop mode" knob to turn it off if you don't want it.

The current alternatives -- mount sync or disable blkdev writeback cache 
-- are far, far slower and punish the entire system just to provide a 
consistency checkpoint for a handful of fsync-needful apps.

	Jeff


