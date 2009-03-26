Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbZCZQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbZCZQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZCZQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:28:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbZCZQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:28:27 -0400
Date: Thu, 26 Mar 2009 09:20:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: <20090326144707.GA6239@mit.edu>
Message-ID: <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu>
 <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Theodore Tso wrote:
>
> Most distributions are putting relatime into /etc/fstab by
> default, but we haven't changed the mount option.

I don't think this is true. Fedora certainly does not. Not in F10, not in 
F11. 

And quite frankly, even if you then _manually_ put 'relatime' in 
/etc/fstab, the default Fedora install will totally ignore it. Why? 
Because it mounts the root partition while using initrd, and totally 
ignores /etc/fstab.

In other words, not only do distributions not do it, but you can't even do 
it by hand afterwards the sane way in the most common distro!

There really is reason for the kernel to just say "user space has sh*t for 
brains, and we'd better change the default - and if some distro really 
_thinks_ about it, and decides that they really want old-fashioned atime, 
let them do that".

Because right now, I do not believe for a moment that any distro that 
defaults to "atime" has spent lots of effort thinking about it. Quite the 
reverse. They probably default to "atime" because they spent no time AT 
ALL thinking about it.

> It wouldn't be hard to add an "atime" option to turn on atime updates, 
> and make either "noatime" or "relatime" the default.  This is a simple 
> patch to fs/namespace.c

Yes. I think we have to.

> No argument here.  I use noatime, myself.  It actually saves a lot
> more than relatime, and unless you are using mutt with local Maildir
> delivery, relatime isn't really that helpful, and the benefit of
> noatime is roughly double that of relatime vs normal atime update, in
> my measurements:
> 
> http://thunk.org/tytso/blog/2009/03/01/ssds-journaling-and-noatimerelatime/

I do agree that "noatime" is better, but with "relatime" you at least are 
likely to not break anything. A program has to be _really_ odd to care 
about the "relatime" vs "atime" behavior.

		Linus
