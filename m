Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXCGBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXCGBry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXCGBrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:47:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42333 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161187AbXCGBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:47:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 17:47:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703061721110.5963@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703061745580.3661@alien.or.mcafeemobile.com>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703061658370.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061721110.5963@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Linus Torvalds wrote:

> 
> 
> On Tue, 6 Mar 2007, Davide Libenzi wrote:
> > 
> > I'm OK with everything that avoid code duplication due to those fake 
> > inodes. The change can be localized inside the existing API, so it doesn't 
> > really affect me externally.
> 
> Can you try with the first patch version that doesn't do anything special 
> at all, and just uses a single dentry.
> 
> Yeah, the dentry name will be identical, and so you would see something 
> like "7 -> signalfd:signalfd" when you do "ls -l /proc/<pid>/fd/" on a 
> task that has such a special file descriptor (with no way to tell 
> different timerfd's and signalfd's apart), but I think it's better to 
> start off simple than to overdesign things.
> 
> And trying to tell them apart sounds a bit like overdesign, if only 
> because I really don't see why anybody would really *care*. So it's a 
> timer for poll/select/epoll - why care about anything else?

The code would not change/shrink much with the single dentry. We'd save 
memory, and we'd lose the capability of seeing aino:[CLASS].
Both ways are fine with me.



- Davide


