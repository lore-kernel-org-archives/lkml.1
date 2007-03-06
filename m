Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbXCFAMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbXCFAMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXCFAMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:12:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37914 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933595AbXCFAMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:12:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 16:12:12 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Linus Torvalds wrote:

> On Mon, 5 Mar 2007, Davide Libenzi wrote:
> > @@ -763,15 +767,17 @@
> >  	 * using the inode number.
> >  	 */
> >  	error = -ENOMEM;
> > -	sprintf(name, "[%lu]", inode->i_ino);
> >  	this.name = name;
> > -	this.len = strlen(name);
> > -	this.hash = inode->i_ino;
> > +	this.len = sprintf(name, "[%p]", ep);
> > +	this.hash = 0;
> 
> Please don't expose kernel pointers to user space.
> 
> It's much better to do something like
> 
> 	static unsigned int epoll_inode;
> 
> 	this.len = sprintf(name, "[%u]", ++epoll_inode);
> 
> if you just need some pseudo-unique name to distinguish two epoll things 
> from each other (vs from a dup'ed fd).

Heh, this is what Al was saying ;)
I'm fine with that, but how about counter cycles (going back to zero)? 
Should we care to handle them correctly? 



- Davide


