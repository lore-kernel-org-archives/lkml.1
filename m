Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbXCHTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbXCHTdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbXCHTdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:33:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43867 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbXCHTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:33:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 11:33:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703081132350.7515@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Linus Torvalds wrote:

> 
> 
> On Thu, 8 Mar 2007, Davide Libenzi wrote:
> >
> > So, to cut it short, I can do the pseudo-siginfo read(2), but I don't 
> > like it too much (little, actually). The siginfo, as bad as it is, is a 
> > standard used in many POSIX APIs (hence even in kernel), and IMO if we 
> > want to send that back, a struct siginfo should be.
> > No?
> 
> I think it's perfectly fine if you make it "struct siginfo" (even though I 
> think it's a singularly ugly struct). It's just that then you'd have to 
> make your read() know whether it's a compat-read or not, which you really 
> can't.
> 
> Which is why you introduced a new system call, but that leads to all the 
> problems with the file descriptor no longer being *usable*.
> 
> Think scripts. It's easy to do reads in perl scripts, and parse the 
> output. In contrast, making perl use a new system call is quite 
> challenging.
> 
> And *that* is why "everything is a stream of bytes" is so important. You 
> don't know where the file descriptor has been, or who uses it. Special 
> system calls for special file descriptors are just *wrong*.
> 
> After all, that's why we'd have a signalfd() in the first place: exactly 
> so that you do *not* have to use special system calls, but can just pass 
> it on to any event waiting mechanism like select, poll, epoll. The same is 
> just *even*more*true* when it comes to reading the data!

"Cheeseburger it is!" ;)
I'll revert back to read(2) with pseudo-siginfo and O_NONBLOCK handling...



- Davide


