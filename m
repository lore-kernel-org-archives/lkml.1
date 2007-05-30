Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXE3WUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXE3WUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXE3WUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:20:16 -0400
Received: from poll.devit.com ([216.165.189.132]:48623 "EHLO mx0.devit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754144AbXE3WUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:20:14 -0400
X-Greylist: delayed 1680 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 18:20:14 EDT
Date: Wed, 30 May 2007 16:51:51 -0500
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
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
Message-ID: <20070530165151.6c2719eb@localhost>
In-Reply-To: <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net>
	<465CA654.5000505@garzik.org>
	<20070530072055.GA3077@elte.hu>
	<465D286E.2080807@redhat.com>
	<20070530084252.GA15708@elte.hu>
	<Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
	<alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
	<465DE992.6070803@redhat.com>
	<alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 14:27:52 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Well, don't think of it as a special case at all: think of bit 30 as
> a "the user asked for a non-linear fd".

If the sole point is to protect an fd from being closed or operated on
outside of a certain context, why not just provide the ability to
"protect" an fd to prevent its use.  Maybe a pair of syscalls like
"fdprotect" and "fdunprotect" that take an fd and an integer key.
Protected fds would return EBADF or something if accessed.  The same
integer key must be provided to fdunprotect in order to gain access
to it again.  Then glibc or valgrind or whatever would just unprotect
the fd before operating on it.

- DML
