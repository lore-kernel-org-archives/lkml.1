Return-Path: <linux-kernel-owner+w=401wt.eu-S936243AbXGQWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936243AbXGQWkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934447AbXGQWkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:40:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:45048 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762674AbXGQWkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:40:23 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 18 Jul 2007 00:40:22 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0707171514290.26781@alien.or.mcafeemobile.com>
Message-ID: <20070717224022.257750@gmx.net>
MIME-Version: 1.0
References: <469D2A40.2060008@gmx.net>
 <Pine.LNX.4.64.0707171514290.26781@alien.or.mcafeemobile.com>
Subject: Re: signalfd and thread semantics
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18f/qkprVUf7kXjnre/qGrTIAZAsc7gPPxB0cyrli
 niYwkUiCCQ+5Rce1xUOGBiGY31IBTUJbWeOw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: HgP7LMcSaHItUtzNXSQlnQBiamdhZMSG
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 17 Jul 2007, Michael Kerrisk wrote:
> 
> > Hi Davide,
> > 
> > Working on the signalfd man page, another question comes up:
> > 
> > What are the intended semantics for a signalfd file descriptor with
> > respect to threads?  I have not yet tested the behavior, but in 
> > any case, I better check what is expected.
> > 
> > A signal can be directed to the process as a whole (e.g., using
> > kill(2)), or to a particular thread (using, e.g., pthread_kill(2), 
> > or tgkill(2)).
> > 
> > So that raises the question: If a thread calls signalfd(), does the
> > resulting file descriptor return just those signals directed to [the
> > thread and the process as a whole], or will it also receive signals 
> > that are targeted at other threads in the process?  I would hope the 
> > former is the case, but I'm not sure what has been implemented 
> > (or intended).
> 
> If thread A calls signalfd(), a read() from the signalfd will return 
> thread A private (tgkill) signals (only when called by thread A) and 
> thread A shared (kill) signals (readable from any thread).
> So a call to signalfd() virtually attaches the fd to the calling thread 
> signal context.
> This is the reason of the "virtual connection" dropped I was talking 
> about in the other email. If the signal context the fd is attached to 
> (struct sighand), goes away, the fd becomes like a disconnected socket 
> with no peer to read form.

It's late at night, and perhaps I am being slow: in what 
circumstances can the signal context go away while the
thread itself continues to live?  (I mean in
what circumstances from the point of view of the userland
program?)

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

