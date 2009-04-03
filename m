Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZDCCZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZDCCZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZDCCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:24:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZDCCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:24:56 -0400
Date: Thu, 2 Apr 2009 19:16:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D56DF6.5020300@garzik.org>
Message-ID: <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org>
 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <49D56DF6.5020300@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Jeff Garzik wrote:
> 
> The most interesting thing I found:  the SSD does 80 MB/s for the first ~1 GB
> or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
> After ~4GB, it reaches a steady speed around 23 MB/s.

Are you sure that isn't an effect of double and triple indirect blocks 
etc? The metadata updates get more complex for the deeper indirect blocks.

Or just our page cache lookup? Maybe our radix tree thing hits something 
stupid. Although it sure shouldn't be _that_ noticeable.

> There is a similar performance fall-off for the Seagate, but much less
> pronounced:
> 	After 1GB:	52 MB/s
> 	After 2GB:	44 MB/s
> 	After 3GB:	steady state

That would seem to indicate that it's something else than the disk speed. 

> There appears to be a small increase in system time with "-f" (use fadvise),
> but I'm guessing time(1) does not really give a good picture of overall system
> time used, when you include background VM activity.

It would also be good to just compare it to something like

	time sh -c "dd + sync"

(Which in my experience tends to fluctuate much more than the steady state 
thing, so I suspect you'd need to do a few runs to make sure the numbers 
are stable).

			Linus
