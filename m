Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXCFA0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXCFA0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbXCFA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:26:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765AbXCFA0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:26:11 -0500
Date: Mon, 5 Mar 2007 16:25:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Davide Libenzi wrote:

> On Mon, 5 Mar 2007, Linus Torvalds wrote:
> > 
> > It's much better to do something like
> > 
> > 	static unsigned int epoll_inode;
> > 
> > 	this.len = sprintf(name, "[%u]", ++epoll_inode);
> > 
> > if you just need some pseudo-unique name to distinguish two epoll things 
> > from each other (vs from a dup'ed fd).
> 
> Heh, this is what Al was saying ;)
> I'm fine with that, but how about counter cycles (going back to zero)? 
> Should we care to handle them correctly? 

Since this is not actually *used* for anything but showing the fd's in 
/proc/<pid>/fd/ etc, no. In fact, an integer will wrap a *lot* less than a 
kernel data structure will be re-used, so even with the simple "wraps 
every 4G uses", you're still better off.

IOW, if the thing actually _mattered_ we should use some bitmap allocator 
or similar (eg pidmaps etc), but with something where the only reason 
really is as a visible indicator of difference for a user that happens to 
look, simple-and-stupid is better.

		Linus
