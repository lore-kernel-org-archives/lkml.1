Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbXCGMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbXCGMC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXCGMC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:02:26 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:13920 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXCGMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HQoV3NPcsAqYCRW9TnQoAbDE+mAmpVqtXxvoq2mimILvaBrprkULMpJcF6dAfynujVnYT9tySJsbS+YfDRK35wB+WaUjKNPz4SyYQ0K7Gzb13BKD8NR41OUmUEA3VSvPpKhEoC6xvrV4nfYU3e3Di2LpwMetwc8O3hVh68LrzvY=
Message-ID: <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
Date: Wed, 7 Mar 2007 09:02:24 -0300
From: "Kirk Kuchov" <kirk.kuchov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070306081935.GB2040@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
	 <20070303100625.GA22557@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
	 <20070303203140.GA756@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
	 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
	 <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com>
	 <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
	 <20070306081935.GB2040@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Pavel Machek <pavel@ucw.cz> wrote:
> > >As for why common abstractions like file are a good thing, think about why
> > >having "/dev/null" is cleaner that having a special plug DEVNULL_FD fd
> > >value to be plugged everywhere,
> >
> > This is a stupid comparaison. By your logic we should also have /dev/stdin,
> > /dev/stdout and /dev/stderr.
>
> Bzzt, wrong. We have them.
>
> pavel@amd:~$ ls -al /dev/std*
> lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stderr -> fd/2
> lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stdin -> fd/0
> lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stdout -> fd/1
> pavel@amd:~$ ls -al /proc/self/fd
> total 0
> dr-x------ 2 pavel users  0 Mar  6 09:18 .
> dr-xr-xr-x 4 pavel users  0 Mar  6 09:18 ..
> lrwx------ 1 pavel users 64 Mar  6 09:18 0 -> /dev/ttyp2
> lrwx------ 1 pavel users 64 Mar  6 09:18 1 -> /dev/ttyp2
> lrwx------ 1 pavel users 64 Mar  6 09:18 2 -> /dev/ttyp2
> lr-x------ 1 pavel users 64 Mar  6 09:18 3 -> /proc/2299/fd
> pavel@amd:~$

I don't believe I'm wasting my time explaining this. They don't exist
as /dev/null, they are just fucking _LINKS_. I could even "ln -s
/proc/self/fd/0 sucker". A real /dev/stdout can/could even exist, but
that's not the point!

It remains a stupid comparison because /dev/stdin/stderr/whatever
"must" be plugged, else how could a process write to stdout/stderr
that it coud'nt open it ? The way things are is not because it's
cleaner to have it as a file but because it's the only sane way.
/dev/null is not a must have, it's mainly used for redirecting
purposes. A sys_nullify(fileno(stdout)) would rule out almost any use
of /dev/null.

> > >As for why common abstractions like file are a good thing, think about why
> > >having "/dev/null" is cleaner that having a special plug DEVNULL_FD fd
> > >value to be plugged everywhere,

> > >But here the list could be almost endless.
> > >And please don't start the, they don't scale or they need heavy file
> > >binding tossfeast. They scale as well as the interface that will receive
> > >them (poll, select, epoll). Heavy file binding what? 100 or so bytes for
> > >the struct file? How many signal/timer fd are you gonna have? Like 100K?
> > >Really moot argument when opposed to the benefit of being compatible with
> > >existing POSIX interfaces and being more Unix friendly.
> >
> > So why the HELL don't we have those yet? Why haven't you designed
> > epoll with those in mind? Why don't you back your claims with patches?
> > (I'm not a kernel developer.)
>
> Either stop flaming kernel developers or become one. It is  that
> simple.
>

If I were to become a kernel developer I would stick with FreeBSD. At
least they have kqueue for about seven years now.

--
Kirk Kuchov
