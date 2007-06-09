Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXFIRE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXFIRE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXFIREW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:04:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1741 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXFIREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:04:21 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 9 Jun 2007 10:04:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Al Viro <viro@ftp.linux.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070609165454.GE4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0706091000530.14037@alien.or.mcafeemobile.com>
References: <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
 <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com>
 <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Al Viro wrote:

> That's simply not true.  On the current kernel nothing stops you from e.g.
> picking a random number and using F_DUPFD.  Voila - there's your randomized
> descriptor.  Portable to earlier kernels.
> 
> Moreover, nonsense^H^H^Hq_fd() can be implemented in userland just fine
> if we allow F_DUPFD to arbitrary number - just pass it a random one *or*
> base chosen like davedel is doing (constant + 20bit random chosen at start
> time).

That does not work. Or better, it works but it forces *huge* fdtables to 
be created. To do that, you need "start" to be over NR_FILE, and this 
creates an fdtable bigger than NR_FILE ((pointer-size + a-few-bits) * 
NR_FILE) propagated down to every app you fork.



- Davide


