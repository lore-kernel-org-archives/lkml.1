Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYDXPGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYDXPGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbYDXPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:06:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:36746 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbYDXPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZsPkjbZeIQT/yrLwZWkdj7IynAStw8z0sO70BlgWH0TG2pGAPyk8FaEwrUpCqQmMQZ/iscfzV0GOfVVUior/hAUXkwPsUUGfdm4nX9pg7hGfzcilw5ISW6uD4bQtvJMBt35pmxj4YGerRjjySel89B1JTPhfY/2bu5spAqnrmyE=
Message-ID: <c49095e30804240805ge3f9ae1qbdcf95ed17cbf151@mail.gmail.com>
Date: Thu, 24 Apr 2008 17:05:45 +0200
From: "Michael Kerrisk" <michael.kerrisk@googlemail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       michael.kerrisk@gmail.com, linux-man@vger.kernel.org
In-Reply-To: <48109DFB.900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	 <20080424112514.055d8071@the-village.bc.nu>
	 <517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>
	 <48109DFB.900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 4:49 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
>  Hash: SHA1
>
>
>  Michael Kerrisk wrote:
>  > * dup2() -- use fcntl(F_DUPFD) instead
>
>  Wrong.  You cannot implement dup2 with fcntl since the latter won't use
>  a file descriptor which is already in use.

True.  One could add a flag to fcntl() to provide that behavior.

>  > So the alternative to sys_indirect(), at least for the purpose of
>  > O_CLOEXEC and similar, would be to create 5 new system calls (or six,
>  > if one finds the signalfd() hack too ugly, which perhaps it is; or 7
>  > if one doesn't like Alan's suggestion for socket()
>
>  Without changing the socket interfaces (plural, socketpair) there would

Yes, I overlooked socket pair()...

>  have to be 7 new syscalls, with changing socket* to an IMO cleaner
>  interface 9.
>
>
>  Or we just add sys_indirect (which is also usable for other syscall
>  extensions, not just the CLOEXEC stuff) and let userlevel (i.e., me)
>  worry about adding new interfaces to libc.  As you can see, for the more
>  recent interfaces like signalfd I have already added an additional
>  parameter so the number of interface changes would be reduced.
>
>  Somebody please make a call and then let's go on with life.  I don't
>  care much either way anymore.  I do hope nobody thinks this is an issue
>  which can be completely ignored (see, e.g., the bug I pointed to the
>  other day).

Since I had to go search, here it is again
http://bugzilla.redhat.com/show_bug.cgi?id=443321
