Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZDCDjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZDCDjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZDCDjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:39:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbZDCDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:39:45 -0400
Date: Thu, 2 Apr 2009 20:34:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D57CF2.5020206@garzik.org>
Message-ID: <alpine.LFD.2.00.0904022030271.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org>
 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <49D56DF6.5020300@garzik.org> <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain> <49D57CF2.5020206@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Jeff Garzik wrote:
> 
> I was really surprised the performance was so high at first, then fell off so
> dramatically, on the SSD here.

Well, one rather simple explanation is that if you hadn't been doing lots 
of writes, then the background garbage collection on the Intel SSD gets 
ahead of the game, and gives you lots of bursty nice write bandwidth due 
to having a nicely compacted and pre-erased blocks.

Then, after lots of writing, all the pre-erased blocks are gone, and you 
are down to a steady state where it needs to GC and erase blocks to make 
room for new writes.

So that part doesn't suprise me per se. The Intel SSD's definitely 
flucutate a bit timing-wise (but I love how they never degenerate to the 
"ooh, that _really_ sucks" case that the other SSD's and the rotational 
media I've seen does when you do random writes).

The fact that it also happens for the regular disk does imply that it's 
not the _only_ thing going on, though.

> Unfortunately I cannot trash these blkdevs, so the raw blkdev numbers are not
> immediately measurable.

Hey, understood. I don't think raw block accesses are even all that 
interesting. But you might try to write the file backwards, and see if you 
see the same pattern.

			Linus
