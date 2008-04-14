Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYDNRNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYDNRNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759787AbYDNRNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:13:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28924 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759088AbYDNRNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:13:37 -0400
Date: Mon, 14 Apr 2008 19:13:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CLONE_IO documentation
Message-ID: <20080414171330.GP12774@kernel.dk>
References: <cfd18e0f0804140540i1c6f035o259a7c4635194f54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0804140540i1c6f035o259a7c4635194f54@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14 2008, Michael Kerrisk wrote:
> Hi Jens,
> 
> Could you supply some text describing CLONE_IO suitable for inclusion
> in the clone.2 man page?
> ( http://www.kernel.org/doc/man-pages/online/pages/man2/clone.2.html
> ).  In that text it would be helpful to explain what an "I/O context"
> is.

Sure, I'll see if I can come up with something. Or perhaps you can help
me a bit, being the writer ;-)

If the CLONE_IO flag is set, the process will share the same io context.
The I/O context is the I/O scope of the disk scheduler. So if you think
of the I/O context as what the I/O scheduler uses to map to a process,
when CLONE_IO is set multiple processes will map to the same I/O context
and will be treated as one by the I/O scheduler. What this means is that
they get to share disk time. For the anticipatory and CFQ scheduler, if
process A and process B share I/O context, they will be allowed to
interleave their disk access. So if you have several threads doing I/O
on behalf of the same process (aio_read(), for instance), they should
set CLONE_IO to get better I/O performance with CFQ and AS.

A man page should not mention the specific schedulers, just mention that
it'll improve the information available to the kernel and the
performance of the app for the scenario described. In practice, it'll
only really apply to CFQ and AS. For deadline and noop, they'll be
essentially zero difference as they have no concept of I/O contexts.


-- 
Jens Axboe

