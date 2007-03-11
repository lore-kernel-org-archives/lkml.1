Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXCKGSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXCKGSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 01:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbXCKGSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 01:18:41 -0500
Received: from alnrmhc16.comcast.net ([204.127.225.96]:49323 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbXCKGSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 01:18:40 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703102119020.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
	 <1173556374.2958.12.camel@entropy>
	 <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
	 <1173560473.2958.23.camel@entropy>
	 <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
	 <1173563796.2958.28.camel@entropy>
	 <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
	 <1173572751.2958.107.camel@entropy>
	 <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
	 <1173577759.2958.124.camel@entropy>
	 <Pine.LNX.4.64.0703102119020.10330@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 22:18:37 -0800
Message-Id: <1173593917.2958.150.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 21:31 -0800, Linus Torvalds wrote:
> 
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> > 
> > Ah, I see. You're just interested in fds as a generic handle concept,
> > and not a more Plan 9 type thing.
> 
> Indeed. It's a "handle".
> 
> UNIX has pid's for "process" handles, and "file descriptors" for just 
> about everything else.

And I imagine that somebody will come up with way of getting a fd for a
process sooner or later. 

> > If that's the goal, somebody should start thinking about reducing the
> > contents of struct file to the bare minimum (i.e. not much more than a
> > file_operations pointer).
> 
> Well, there's more there, but it really is fairly close. If you look at 
> it, a "struct file" ends up not having a lot more than the minimal stuff 
> required to use it as a a handle: it really isn't a very big structure. 
> 
> The biggest part is actually the read-ahead state, which is arguably a 
> generic thing for a file handle, even though not all kinds will be able to 
> use it. We *could* make that be behind a pointer (along with the "f_pos" 
> thing, that really logically goes along with the read-ahead thing), of 
> course, but since most files probably do end up being "traditional file" 
> structures, it's probably not wrong to just have it in the file.
> 

Actually, I was thinking reducing struct file to the bare minimum, and
then using that as the common header shared by object-specific
structures. I don't know how unpleasant that would be from a memory
allocation perspective, though.

-- 
Nicholas Miell <nmiell@comcast.net>

