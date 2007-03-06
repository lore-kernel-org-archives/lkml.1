Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXCFIUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXCFIUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXCFIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:20:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36319 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbXCFIUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:20:06 -0500
Date: Tue, 6 Mar 2007 09:19:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kirk Kuchov <kirk.kuchov@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070306081935.GB2040@elf.ucw.cz>
References: <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com> <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com> <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com> <20070303203140.GA756@2ka.mipt.ru> <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com> <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com> <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com> <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >As for why common abstractions like file are a good thing, think about why
> >having "/dev/null" is cleaner that having a special plug DEVNULL_FD fd
> >value to be plugged everywhere,
> 
> This is a stupid comparaison. By your logic we should also have /dev/stdin,
> /dev/stdout and /dev/stderr.

Bzzt, wrong. We have them.

pavel@amd:~$ ls -al /dev/std*
lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stderr -> fd/2
lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stdin -> fd/0
lrwxrwxrwx 1 root root 4 Nov 12  2003 /dev/stdout -> fd/1
pavel@amd:~$ ls -al /proc/self/fd
total 0
dr-x------ 2 pavel users  0 Mar  6 09:18 .
dr-xr-xr-x 4 pavel users  0 Mar  6 09:18 ..
lrwx------ 1 pavel users 64 Mar  6 09:18 0 -> /dev/ttyp2
lrwx------ 1 pavel users 64 Mar  6 09:18 1 -> /dev/ttyp2
lrwx------ 1 pavel users 64 Mar  6 09:18 2 -> /dev/ttyp2
lr-x------ 1 pavel users 64 Mar  6 09:18 3 -> /proc/2299/fd
pavel@amd:~$

> >But here the list could be almost endless.
> >And please don't start the, they don't scale or they need heavy file
> >binding tossfeast. They scale as well as the interface that will receive
> >them (poll, select, epoll). Heavy file binding what? 100 or so bytes for
> >the struct file? How many signal/timer fd are you gonna have? Like 100K?
> >Really moot argument when opposed to the benefit of being compatible with
> >existing POSIX interfaces and being more Unix friendly.
> 
> So why the HELL don't we have those yet? Why haven't you designed
> epoll with those in mind? Why don't you back your claims with patches?
> (I'm not a kernel developer.)

Either stop flaming kernel developers or become one. It is  that
simple.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
