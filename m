Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZDUTmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZDUTmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZDUTl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:41:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53040 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZDUTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:41:58 -0400
Date: Tue, 21 Apr 2009 20:39:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
References: <20090330123101.GQ28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com>
 <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com>
 <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
 <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Linus Torvalds wrote:
> On Tue, 21 Apr 2009, Oleg Nesterov wrote:
> > 
> > OK, I agree, it doesn't really matter from latency/etc pov.
> > 
> > But still I can't understand why it is better to take fs->lock under
> > RCU lock. I mean, "fs->lock is the innermost lock" should not apply
> > to rcu_read_lock(). Because the latter is a bit special, no?
> 
> Oh, I don't think it matters. If you want to put the RCU read-lock 
> innermost, that's fine by me. I just reacted to your latency argument as 
> not being very strong :)
> 
> All I personally want is a patch that everybody can agree on, and that 
> has sane semantics. 

Right, that ordering scarcely matters, and can probably be argued
either way.  I should have been clearer when I suggested inverting
them to Oleg: I meant it merely as a suggestion, that we go back
to the ordering which came more naturally to Al in the first place.
And since Al hasn't spoken up (probably has more important things
to care about), please do go ahead with your two patches, Oleg,
with the rcu_read_lock() on whichever side takes your fancy!

Thanks,
Hugh
