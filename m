Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXFIQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXFIQzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXFIQzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:55:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59159 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXFIQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:55:03 -0400
Date: Sat, 9 Jun 2007 17:54:54 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609165454.GE4095@ftp.linux.org.uk>
References: <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466AD4BA.80407@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:26:34AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Al Viro wrote:
> > So which code is supposed to do that open/write in your example?  Library?
> > Unmodified application?  Application specifically modified to make *that*
> > open() randomized?
> 
> Why should that matter?  All of the above.

I asked for real-world example.  Can I have one, please?

> In whatever way you look at it, there currently is a problem which
> cannot be solved except with truly horrible, horrible hack (open N
> descriptors and randomly select one to use; yep, horrible, I said so).

That's simply not true.  On the current kernel nothing stops you from e.g.
picking a random number and using F_DUPFD.  Voila - there's your randomized
descriptor.  Portable to earlier kernels.

Moreover, nonsense^H^H^Hq_fd() can be implemented in userland just fine
if we allow F_DUPFD to arbitrary number - just pass it a random one *or*
base chosen like davedel is doing (constant + 20bit random chosen at start
time).
