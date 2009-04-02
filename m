Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZDBXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZDBXGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZDBXGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:06:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbZDBXGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:06:32 -0400
Date: Thu, 2 Apr 2009 16:00:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: jeff@garzik.org, drees76@gmail.com, j@jannau.net,
       lsorense@csclub.uwaterloo.ca, tytso@mit.edu, jesper@krogh.cc,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
In-Reply-To: <20090402155156.33d98b27.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904021553070.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org>
 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <20090402155156.33d98b27.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Andrew Morton wrote:
> 
> The thing which has always worried me about trying to do smart
> drop-behind is the cost of getting it wrong - and sometimes it _will_
> get it wrong.
> 
> Someone out there will have an important application which linearly
> writes a 1G file and then reads it all back in again.  They will get
> really upset when their runtime doubles.

Yes. The good news is that it would be a pretty easy tunable to have a 
"how soon do we writeback and how soon would we drop". And I do suspect 
that _dropping_ should default to off (exactly because of the kind of 
situation you bring up). 

As mentioned, at least in my experience the VM is pretty good at dropping 
the right pages anyway. It's when they are dirty or locked that we end up 
stuttering (or when we do fsync). And "start background writeout earlier" 
improves that case regardless of drop-behind.

But at the same time it is also unquestionably true that the current 
behavior tends to maximize throughput performance. Delaying the writes as 
long as possible is almost always the right thing for througput. 

In my experience, at least on desktops, latency is a lot more important 
than throughput is. And I don't think anybody wants to start the writes 
_immediately_. 

			Linus
