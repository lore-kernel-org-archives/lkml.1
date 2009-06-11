Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZFKSUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZFKSUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZFKSUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:20:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958AbZFKSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:20:08 -0400
Date: Thu, 11 Jun 2009 11:18:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
In-Reply-To: <20090611111339.GQ11363@kernel.dk>
Message-ID: <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain>
References: <20090611111339.GQ11363@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Jens Axboe wrote:
> 
> This is the bulk of the block changes for 2.6.31, please pull.
> 
>   git://git.kernel.dk/linux-2.6-block.git for-2.6.31

Ok, this clashed pretty badly with both the tracing tree (which obviously 
has block tracers) and with my pull ide pull from Bartlomiej (which 
obviously has ide driver changes).

I fixed everything up, and it _looks_ ok, including a "allyesconfig" build 
etc. It wasn't totally trivial, though - in the sense that it's entirely 
possible that I fixed something up incorrectly. Also, in the tracer code, 
I kept the checks for whether something is a "pc" of "fs" request, so it 
now looks like

	__entry->sector    = blk_pc_request(rq) ? 0 : blk_rq_pos(rq);

and I suspect that it could just be an unconditional

	__entry->sector    = blk_rq_pos(rq);

instead, but somebody involved with the whole block tracing thing needs to 
check that out. 

The ide-tape.c changes also need some expert tender loving checks. I 
neither know the code, nor have the hardware to check my fixups. Almost 
all the changes are actually by the same person - it's almost all Tejun's 
code (and mostly the same patches), just coming in through two different 
trees. Not very nice.

Btw, Jens: in your tree, you've committed Tejun's changes without adding 
your own sign-off. Not good!

			Linus
