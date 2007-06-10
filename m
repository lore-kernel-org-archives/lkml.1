Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXFJEEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXFJEEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbXFJEEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:04:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbXFJEEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:04:39 -0400
Date: Sat, 9 Jun 2007 21:03:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070610040014.GD21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706092102300.20321@woody.linux-foundation.org>
References: <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
 <20070610040014.GD21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Al Viro wrote:

> On Sat, Jun 09, 2007 at 08:48:39PM -0700, Linus Torvalds wrote:
> > Agreed. That was actually part of the reason why I thought clone() was
> > much better than the pthreads interface.
> > 
> > That said, the Linux !CLONE_FILES does have downsides:
> > 
> >  - it is potentially much slower to do than sharing everything (if you 
> >    have lots of file descriptors, incrementing the refcounts etc is 
> >    actually a real overhead)
> 
> Huh?  We _skip_ the overhead when descriptor table is not shared.

Not for clone()/exit(), ie the actual _creation_ of the thread.

		Linus
