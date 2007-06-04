Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXFDOUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXFDOUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbXFDOUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:20:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52713 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbXFDOUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AhRB5T7ExdFQbAW/avr/ac6BIp6L4xRzSSAMhDLJi5LyXGAKen9Thf4Xf5nxz9li3cStAwIoq67iLZ3i9poh8w+Sadd9tEGHdbf8nOvTgPV3Cuv5DIbIpimsg6kWeK57DraI/ihDoH4MOZ5Djq+9+CxYFGSdlN0jvdAxm8+xLBQ=
Message-ID: <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:20:00 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to David Schwartz here.. (David, good to hear from you again
- haven't seen you around since the irc days :))

David Schwartz wrote:
>
> There is no way you can re-try the request. The open must either succeed or
> not return a handle. It is not like a 'read' operation that has an "I didn't
> do anything, and you can retry this request" option.
>
> If 'open' returns a file handle, you can't retry it (since it must succeed
> in order to do that, failure must not return a handle). If you 'open'
> doesn't return a file handle, you can't retry it (because, without a handle,
> there is no way to associate a future request with this one, if it creates a
> file, the file must not be created if you don't call 'open' again).

I understand, but this is exactly the situation that I'm complaining
about.  There is no functionality to provide a nonblocking open - no
ability to come back around and retry a given open call.

> You need either threads or a working asynchronous system call interface.
> Short of that, you need your own NFS client code.

This is exactly my point - there is no asynchronous system call to do
this work, to my knowledge.  I will likely fix this in my own code
using threads, but I see using threads in this case as working around
that lack of systems interface.  Threads, imho, should be limited to
cases where I'm using them to distribute load across multiple
processors, not because the kernel interfaces for IO cannot support
nonblocking calls.

I'm speaking to my ideal world view - but any application I write
should not have to wait for the kernel if I don't want it to.   I
should be able to submit my request, and come back to it later as I so
decide.

(And I did actually consider writing my own NFS client for about 5 minutes.)

Thanks for the response!
-Aaron
