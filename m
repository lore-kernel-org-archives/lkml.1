Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZDURo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZDURo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZDURoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:44:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbZDURoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:44:12 -0400
Date: Tue, 21 Apr 2009 10:35:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hugh@veritas.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090421171530.GA12014@redhat.com>
Message-ID: <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
References: <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
 <20090421171530.GA12014@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Oleg Nesterov wrote:
> 
> OK, I agree, it doesn't really matter from latency/etc pov.
> 
> But still I can't understand why it is better to take fs->lock under
> RCU lock. I mean, "fs->lock is the innermost lock" should not apply
> to rcu_read_lock(). Because the latter is a bit special, no?

Oh, I don't think it matters. If you want to put the RCU read-lock 
innermost, that's fine by me. I just reacted to your latency argument as 
not being very strong :)

All I personally want is a patch that everybody can agree on, and that 
has sane semantics. 

		Linus
