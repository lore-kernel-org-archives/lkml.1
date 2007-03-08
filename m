Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXCHUx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXCHUx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbXCHUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:53:28 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:35688 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbXCHUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:53:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=undjDttFSV8WrjrmD3FaG/nb2pgLF4L5x5bqZ06G3ClifCa1lx3NDKsHnagXosYCPj69QN+LjU3ebALDXQApKcwrPUZPNU+lMgstiQWDpxPIKrwvkveZa0VS04KtIqVrIqSHQxg5fyNGHRZOOINPXIsPoXlgA4Nv8VQRKBK6ykA=
Message-ID: <f2b55d220703081253s5c42d174ndf4653f871746caa@mail.gmail.com>
Date: Thu, 8 Mar 2007 12:53:26 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703080919541.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
	 <1173364264.6891.3.camel@localhost>
	 <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
	 <f2b55d220703080840xb0a1da0w41051a7c4a7ac4e3@mail.gmail.com>
	 <Pine.LNX.4.64.0703080919541.10832@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> So anybody who would "go with the Berkeley crowd" really shows a lot of
> bad taste, I'm afraid. The Berkeley crowd really messed up here, and it's
> so long ago that I don't think there is any point in us trying to fix it
> any more.

Well, they did invent the socket, which sucks less than a lot of other
things.  You would prefer STREAMS, perhaps?  :-)  My point is that
this is a message-oriented problem, not a stream-oriented problem, and
read() just isn't a very good interface for passing structured
messages around.  I agree that the details of recvmsg() ancillary data
are fairly grotty (optimization based on micro-benchmarks, as usual,
back in the PDP/VAX days), but the concept isn't that bad; you let
netlink sockets into the kernel, didn't you?

> (But if somebody makes recvmgs a general VFS interface and makes it just
> work for everything, I'd probably take the patch as a cleanup. I really
> think it should have been a "struct file_operations" thing rather than
> being a socket-only thing.. But since you couldn't portably use it
> anyway, the thing is pretty moot)

sendmsg()/recvmsg() to a file makes perfect sense, if you put the
equivalent of an llseek tuple into ancillary data.  And it's also IMHO
the right way to do file AIO -- open up a netlink socket to the entity
that's scheduling the IOs for a given filesystem, use the SCM_RIGHTS
mechanism to do indirect opens (your credentials could come over an
AF_UNIX socket from a completely separate "open server" process), and
multiplex all the AIO to that filesystem across the netlink socket.

If adding this to VFS is something you would seriously consider, I'll
do the work.  But I will need some coaching to work around my relative
inexperience with the Linux core code and my lack of taste.  :-)

Cheers,
- Michael
