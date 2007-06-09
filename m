Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXFIEMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXFIEMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 00:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXFIEM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 00:12:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:32834 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXFIEM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 00:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PKsZXYG8fOQbfKSXB2cJn1W1yOW0KOQRAv+gN5/Jfpn2ruolVei1eOtQ4+nDdgZ9bh9a4pll0cjT0VhKoMrY1wXeekkP69oJBFiKfk0kvMiQ1MODA8jufxuWdA7GomQ6KKpd6dh1u3jyocZhVJu9K5FSDKF4YMlm2+4cjGHuTBw=
Message-ID: <787b0d920706082112v25fb118ew3556eb868c118c1c@mail.gmail.com>
Date: Sat, 9 Jun 2007 00:12:25 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Davide Libenzi" <davidel@xmailserver.org>
In-Reply-To: <4669009E.3000702@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <4669009E.3000702@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Albert Cahalan a écrit :

> > Additions to better support JIT emulators:
> >
> > a. sysctl to set IPC_RMID by default
>
> Not very good, this will break some apps.

As a sysctl, the admin gets to choose between
compatibility and sanity.

I can see such a sysctl also being really helpful for a
shared computer used for an Operating Systems or
System Programming course.

> > b. shmget() flag to set IPC_RMID by default
>
> This is better :)

Both are good. This one requires that all apps using
SysV shared memory be modified to use the flag.
The other requires that a very few apps be modified
to tolerate a behavior change.

> > c. open() flag to unlink a file before returning the fd
>
>
> Well, I assume you would like fd = open("/path/somefile", O_RDWR | O_CREAT |
> O_UNLINK, 0644)
>
> (ie allocate a file handle but no name ?)

Yes.

> Quite difficult to implement this atomically with current vfs, maybe a new
> syscall would be better. (Linus will kill me for that :) )
>
> (We dont need to insert "somefile" in one directory, then unlink it, we only
> need to allocate an unnamed inode to get some backing store)

I suspect that SMB/CIFS has a native call for this. There is
some sort of tmpfile flag defined over in that world.
