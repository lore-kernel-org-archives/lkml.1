Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZCSRDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZCSRDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZCSRDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:03:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZCSRDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:03:44 -0400
Date: Thu, 19 Mar 2009 18:03:40 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ying Han <yinghan@google.com>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090319170340.GC3899@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200903200248.22623.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903190902000.17240@localhost.localdomain> <200903200334.55710.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903190948510.17240@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903190948510.17240@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-03-09 09:51:59, Linus Torvalds wrote:
> 
> 
> On Fri, 20 Mar 2009, Nick Piggin wrote:
> > 
> > Yeah, probably no need to hold private_lock while tagging the radix
> > tree (which is what my version did). So maybe this one is a little
> > better. I did test mine, it worked, but it didn't solve the problem.
> 
> Ahh, so you re-created it? On ext2 only, or is it visible on ext3 as well? 
> I've not even tested - I assumed that I would have to boot into less 
> memory and downgrade my filesystem to ext2, which made me hope somebody 
> else would pick it up first ;)
  In thread http://lkml.org/lkml/2009/3/4/179 I've reported similar problem
- write lost. I'm able to reproduce under UML linux at will. ext3 takes
with 1KB blocksize about 20 minutes to hit the corruption, ext2 with 1 KB
blocksize about an hour, ext2 with 4KB blocksize several hours...
  I've reported that also ordinary write() got lost once but that might
have been an error in me reading the fsx logs since I never saw it again...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
