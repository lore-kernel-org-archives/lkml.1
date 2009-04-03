Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbZDCPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbZDCPdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbZDCPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:33:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848AbZDCPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:33:25 -0400
Date: Fri, 3 Apr 2009 08:28:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D627DF.6090501@rtr.ca>
Message-ID: <alpine.LFD.2.00.0904030823140.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
 <49D627DF.6090501@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Mark Lord wrote:
> 
> Note that for mythtv, this may not be the best behaviour.
> 
> A common use scenario is "watching live TV", a few minutes behind
> real-time so that the commercial-skipping can work its magic.
> 
> In that scenario, those pages are going to be needed again
> within a short while, and it might be useful to keep them around.
> 
> But then Myth itself could probably decide whether to discard them
> or not, not based upon that kind of knowledge.

Yes. I suspect that Myth could do heuristics like "when watching live TV, 
do drop-behind about 30s after the currently showing stream". That still 
allows for replay, but older stuff you've watched really likely isn't all 
that interesting and migth be worth dropping in order to make room for 
more data.

And you can use posix_fadvise() for that, since it's now no longer 
connected with "wait for background IO to complete" at all.

The reason for wanting "SYNC_FILE_RANGE_DROP" was simply that I was doing 
the "wait after write" anyway, and thinking I wanted to get rid of the 
pages while I was already handling them. But that was for an app where I 
_new_ the data was uninteresting as soon as it was on disk. Doing a secure 
delete is different from recording video ;)

				Linus
