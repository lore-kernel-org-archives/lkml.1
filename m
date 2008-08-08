Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYHHAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYHHAit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYHHAig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:38:36 -0400
Received: from zen.handcraftedcomputers.com.au ([203.122.247.90]:4587 "EHLO
	zen.handcraftedcomputers.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294AbYHHAie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:38:34 -0400
Message-ID: <489B957D.9080206@handcraftedcomputers.com.au>
Date: Fri, 08 Aug 2008 10:08:21 +0930
From: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sven Wegener <sven.wegener@stealer.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM?: "permission denied" when accessing /proc/self/fd/*
 after setuid
References: <489A9357.50105@handcraftedcomputers.com.au> <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net>
In-Reply-To: <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Wegener wrote:

> If a program wants to fiddle with an existing _file_descriptor_, it should 
> use the dup syscalls or access the descriptor directly.

If you have the source to the program, and can (and are allow to) modify
it, then yes I agree, but that isn't always an option.  And I guess why
have the interface in the first place if we have dup() and friends?.

> Don't know if the behaviour of /dev/std* and /proc/self/fd/* is 
> standardized in some way. But I guess it's implementation-specific.

I guess that's something I was after - if this behavior was defined.
My *belief* (which is questionable) is that it was to emulate dup()
behavior, which it obviously isn't in this case.

>> The above environment isn't necessary to replicate the problem, although
>> what stdout and stderr are attached to has some effect.  The attached C
>> code replicates the issue, but appears to not fail (that is, succeed) if
>> /proc/self/fd/2 is a terminal (e.g. /dev/pts/X) *and* that terminal is
>> owned by the same uid that the code uses (in this case, 500). In the
>> case of an anonymous pipe it appears to fail consistently as the pipe is
>> owned by root.

> Why should it fail for the terminal? You're the owner of it.

I didn't expect it to fail, but then I didn't expect it to fail under any
condition.  That it's failing for the other conditions is my beef.  :-)

> Don't have a FreeBSD installation at my fingers, so can't verify. Maybe 
> they just don't use symlinks to represent the open files, so they do not 
> end up opening the original file.

According to the man page on my crufty 4.11 box:

    If the file descriptor is open and the mode the file is being opened
    with is a subset of the mode of the existing descriptor, the call:

           fd = open("/dev/fd/0", mode);

    and the call:

           fd = fcntl(0, F_DUPFD, 0);

    are equivalent.

I don't have a more recent box handy, but the man page at
<http://www.freebsd.org/cgi/man.cgi?query=stderr&apropos=0&sektion=0&manpath=FreeBSD+7.0-RELEASE&format=html>
infers that this is still the case.

> As said above, don't know if the behaviour is standardized.

Anybody?  Bueller?

Thanks for the response; they warned me this was a high traffic list.  :-)


Cheers,
  --dt
