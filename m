Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbXE3VSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbXE3VSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXE3VS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:18:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbXE3VS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:18:28 -0400
Message-ID: <465DE992.6070803@redhat.com>
Date: Wed, 30 May 2007 14:16:02 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 	for (i = 0; i < NR_OPEN; i++)
> 		close(i);
> 
> to clean up all file descriptors before doing something new. And yes, I 
> think it was bash that used to *literally* do something like that a long 
> time ago.

Indeed.  It was not only bash, though, I fixed probably a dozen
applications.  But even the new and better solution (readdir of
/proc/self/fd) does not prevent the problem of closing descriptors the
system might still need and the application doesn't know about.


> Which *could* be something as simple as saying "bit 30 in the file 
> descriptor specifies a separate fd space" along with some flags to make 
> open and friends return those separate fd's.

I don't like special cases.  For me things better come in quantities 0,
1, and unlimited (well, reasonable high limit).  Otherwise, who gets to
use that special namespace?  The C library is not the only body of code
which would want to use descriptors.

And then the semantics: do these descriptors should show up in
/proc/self/fd?  Are there separate directories for each namespace?  Do
they count against the rlimit?

This seems to me like a shot from the hips without thinking about other
possibilities.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXemS2ijCOnn/RHQRAjsFAKCGhakZosSsRzCwOvruxECbzcwIzACeJAiY
z9ql4FJa8XTSiZzRG79ocwM=
=0E7f
-----END PGP SIGNATURE-----
