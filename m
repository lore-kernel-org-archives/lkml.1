Return-Path: <linux-kernel-owner+w=401wt.eu-S1767484AbXCIUWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767484AbXCIUWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767485AbXCIUWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:22:30 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:48964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767484AbXCIUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JTgJdedyNp0RkHo+AHHjnAw6OXpoJDZowKiNe/M6NQn9OenbtZyXB0+wEedPiceaGsfNMd7bYLYFrGn2O3bfp4VD2dcaWyfdCBvokW0MF/lC7EnPAtVhyni3FcDDjOIWOxKB/gorGawOdjYx3fMhdPBl4obxzrYdVjVvXY+D0kQ=
Message-ID: <6f703f960703091222w512af954s7cf245b02d78d1bd@mail.gmail.com>
Date: Fri, 9 Mar 2007 11:22:27 -0900
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
	 <1173364264.6891.3.camel@localhost>
	 <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703081123210.10832@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Which is why you introduced a new system call, but that leads to all the
> problems with the file descriptor no longer being *usable*.
>
> Think scripts. It's easy to do reads in perl scripts, and parse the
> output. In contrast, making perl use a new system call is quite
> challenging.

If you're going to allow reads from the fd, then it makes sense to let processes
get the fd by opening a file; if you've got to call siginfo_create()
or what have
you, the fact that you can do reads isn't terribly useful to perl or
what have you.

Inotify even makes you get events with read() today; but you have to use system
calls to get the fd and to send events (inotify_add_watch, inotify_rm_watch),
which is something I've never understood.

It would, to me, be very cool if everything that was a stream of bytes
really was
a file; this is something I've always thought plan 9 got very right. Epoll and
inotify could work this way, and I'm sure there's others I'm forgetting.

If people are interested in this sort of thing, I'll start working on
a patch. Are there
any thoughts on where these sorts of pseudodevices should be these days?
