Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZDDRrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZDDRrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZDDRq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:46:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbZDDRq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:46:56 -0400
Date: Sat, 4 Apr 2009 10:44:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <20090404173412.GF5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu>
 <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Apr 2009, Jens Axboe wrote:
> > 
> > I'm sorry, but that fsync thing _is_ a real-world case, and it's the one 
> > that a hell of a lot more people care about than some idiotic sqlite 
> > throughput issue.
> 
> sqlite is just one case, I'm sure there are others. My point is that we
> should make sure that we don't regress on the throughput side. It's a
> trade off, we don't want throughput to fall through the floor either.

Jens, we _have_ regressed on the latency side. Everybody agrees. 

Also, I may be odd, but I really do think latency is more important than 
throughput. When my disk has latencies in the sub-milliseconds, I simply 
do not think it is _acceptable_ to have hickups that affect my workload in 
human-visible terms. 

You say sqlite might regress by 4-5x. But Ted's numbers improve latencies 
by mor than that. I haven't re-created them yet myself (still reading 
email), but the point is, 4-5x may sound bad to you, but turn it around: 
the current latency situation is _really_ bad. If we can fix it, we 
definitely should.

> > Quite frankly, the fact that I can see _seconds_ of latencies with a 
> > really good SSD is not acceptable. The fact that it is by design is even 
> > less so.
> 
> Agree, multi-second latencies is not acceptable.

I can literally send you strace output from my MUA, where it pauses for 
ten seconds after it has written about 5kB (that's _kilobytes_) of data 
and does a 'fsync'.

That's the load that Ted worked on and has a solution for.

		Linus
