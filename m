Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZFKS1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZFKS1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZFKS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:26:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52744 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZFKS04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:26:56 -0400
Date: Thu, 11 Jun 2009 20:26:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
Message-ID: <20090611182657.GY11363@kernel.dk>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11 2009, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Jens Axboe wrote:
> > 
> > This is the bulk of the block changes for 2.6.31, please pull.
> > 
> >   git://git.kernel.dk/linux-2.6-block.git for-2.6.31
> 
> Ok, this clashed pretty badly with both the tracing tree (which obviously 
> has block tracers) and with my pull ide pull from Bartlomiej (which 
> obviously has ide driver changes).
> 
> I fixed everything up, and it _looks_ ok, including a "allyesconfig" build 
> etc. It wasn't totally trivial, though - in the sense that it's entirely 
> possible that I fixed something up incorrectly. Also, in the tracer code, 
> I kept the checks for whether something is a "pc" of "fs" request, so it 
> now looks like
> 
> 	__entry->sector    = blk_pc_request(rq) ? 0 : blk_rq_pos(rq);
> 
> and I suspect that it could just be an unconditional
> 
> 	__entry->sector    = blk_rq_pos(rq);
> 
> instead, but somebody involved with the whole block tracing thing needs to 
> check that out. 
> 
> The ide-tape.c changes also need some expert tender loving checks. I 
> neither know the code, nor have the hardware to check my fixups. Almost 
> all the changes are actually by the same person - it's almost all Tejun's 
> code (and mostly the same patches), just coming in through two different 
> trees. Not very nice.

I agree, that part is a mess. Hopefully we wont have this degree of
churn in this area again, but I do wish that we had more block consumers
based off the block tree. Having cross-dependent stuff in different
trees just gets messy quickly. Thanks for resolving it though, the IDE
code wasn't pulled in when I sent the pull request or I would've done it
myself. I usually try to make sure that it merges cleanly with your head
of tree before sending it out.

> Btw, Jens: in your tree, you've committed Tejun's changes without adding 
> your own sign-off. Not good!

That's for the patches that I pulled from his git tree. It should list
him as committer too.

-- 
Jens Axboe

