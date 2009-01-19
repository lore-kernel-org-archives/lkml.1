Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZASSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZASSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZASSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:25:08 -0500
Received: from brick.kernel.dk ([93.163.65.50]:25681 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZASSZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:25:06 -0500
Date: Mon, 19 Jan 2009 19:23:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth K <nikanth@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090119182336.GS30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <807b3a220901190745w79827b41u1cc9045a2ac268e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <807b3a220901190745w79827b41u1cc9045a2ac268e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19 2009, Nikanth K wrote:
> On Sun, Jan 18, 2009 at 12:34 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> >
> > As a quick test, could you try and increase the slice_idle to eg 20ms?
> > Sometimes I've seen timing being slightly off, which makes us miss the
> > sync window for the ls (in your case) process. Then you get a mix of
> > async and sync IO all the time, which very much slows down the sync
> > process.
> >
> 
> Do you mean to say that 'ls' could not submit another request until
> the previous sync request completes, but its idle window gets disabled
> as it takes way too long to complete during heavy load? But when there

'ls' would never submit a new request before the previous one completes,
such is the nature of sync processes. That's the whole reason we have
the idle window.

> are requests in the driver, wont the idling be disabled anyway? Or did
> you mean to increase slice_sync?

No, idling is on a per-cfqq (process) basis. I did not mean to increase
slice_sync, that wont help at all. It's the window between submissions
of requests that I wanted to test being larger, but apparently that
wasn't the case here.

-- 
Jens Axboe

