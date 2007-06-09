Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXFIPPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXFIPPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXFIPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:15:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbXFIPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:15:33 -0400
Date: Sat, 9 Jun 2007 16:15:21 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609151521.GD4095@ftp.linux.org.uk>
References: <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466A0BFB.3070908@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 07:10:03PM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Al Viro wrote:
> > Any real-world examples of exploitable holes based on that?
> 
> Return to libc exploit, calling dup2, where some privileged data is
> redirected from the normal file descriptor to one of the attackers
> choosing.  The latter could be an outgoing socket connection which would
> result in leaking the data to the outside.
> 
>          normal code                         intruder
> 
>                                           so = socket()
> 
>     fd = open ("local-file")
> 
>                                           dup2(so, fd);
> 
>     write (fd, privileged data)
> 
> 
> It's just a little function call.  If the arguments of dup2() are known
> this is not a big issue to construct.

So which code is supposed to do that open/write in your example?  Library?
Unmodified application?  Application specifically modified to make *that*
open() randomized?
