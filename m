Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbXFJPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbXFJPMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXFJPMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:12:38 -0400
Received: from [81.2.110.250] ([81.2.110.250]:38684 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024AbXFJPMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:12:37 -0400
Date: Sun, 10 Jun 2007 16:16:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610161616.301b9680@the-village.bc.nu>
In-Reply-To: <466BC0E3.4050600@cosmosbay.com>
References: <20070609003622.GB4095@ftp.linux.org.uk>
	<466A0020.50406@redhat.com>
	<20070609014140.GC4095@ftp.linux.org.uk>
	<466A0BFB.3070908@redhat.com>
	<20070609151521.GD4095@ftp.linux.org.uk>
	<466AD4BA.80407@redhat.com>
	<20070609165454.GE4095@ftp.linux.org.uk>
	<466ADEAB.7080202@redhat.com>
	<20070609172429.GF4095@ftp.linux.org.uk>
	<2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
	<20070609200645.GG4095@ftp.linux.org.uk>
	<alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
	<466BC0E3.4050600@cosmosbay.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > and there's absolutely nothing wrong with this kind of setup, even if you 
> > could obviously have done it other ways too (ie by using "dup2()" instead 
> > of "close + open"),
> > 
> 
> This kind of setup was OK 25 years ago, before multithreading era.
> You cannot reasonably expect it to work in a multithreaded program.

Why not.

When execution begins which is the normal point you do this then you've
got one thread. If you need to do this from a thread after that point
posix provides threaded applications with locking.

Not much else works in a threaded app if you get the locking wrong, and
that is considered the authors job. Why is fd allocation different ?
