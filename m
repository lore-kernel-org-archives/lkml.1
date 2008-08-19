Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYHSLou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYHSLou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYHSLoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:44:39 -0400
Received: from pruts.nl ([82.94.235.106]:50627 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbYHSLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:44:37 -0400
Date: Tue, 19 Aug 2008 13:44:23 +0200
From: Ico Doornekamp <lkml@zevv.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080819114423.GB29842@pruts.nl>
References: <20080810150859.GO3653@pruts.nl> <20080819004026.2dac3ba6.akpm@linux-foundation.org> <20080819075414.GV29842@pruts.nl> <20080819010702.c5300420.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819010702.c5300420.akpm@linux-foundation.org>
X-Prutser: true
X-PGP-key: 4202FA2F
X-PGP-KeyServer: subkeys.pgp.net
X-PGP-Fingerprint: F042 F5CD B0A6 EC6A CB80  A829 CACD A4B5 4202 FA2F
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :

> On Tue, 19 Aug 2008 09:54:14 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> 
> > 
> > 
> > * On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :
> > 
> > > On Sun, 10 Aug 2008 17:08:59 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> > > 
> > > > Recently my X terminals showed annoying behaviour where the application
> > > > in the terminal was not resized properly to the actual size of the X
> > > > terminal emulator window, resulting in a lot of misaligned text on the
> > > > screen. Hunting the issue down from the windowmanager and the terminal
> > > > emulator program, I suspect the problem might lie in the kernel. I'm
> > > > running 2.6.26 on a dual core i386.
> > > > 
> > > > What I see is this: the userspace application receives a SIGWINCH signal
> > > > and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
> > > > in some cases the old instead of the new terminal size is returned.
> > > > A small delay before the ioctl seems to 'fix' this behaviour.
> > > > 
> > > > I noticed some changes involving locking in the the pty code in the last
> > > > kernel verions, could one of these changes cause the above behaviour ? If
> > > > so, wouldn't this affect much more users ?
> > > 
> > > hm, that code is pretty simple and although it does the SIGWINCH and
> > > the window-size setting in a peculiar order, it looks to be race-free.
> > > 
> > > Approximately what proportion of the time does it go wrong?
> > 
> > I guess about 10 to 20% of the resizes. I happen to be using a tiling
> > window manager which causes resizing more often and more agressive then
> > 'normal' window managers, I guess this helps triggering the problem.
> > 
> > I temporary worked around this issue this by changing the order of the
> > signal and the updating of the pty size in tty_io.c's tiocswinsz(), but
> > this is not much of a real fix.
> > 
> 
> Well damn.  Are you sure?  The code looks solid to me.
> 
> At least, it does after 
> 
> Author: Alan Cox <alan@redhat.com>  2008-08-15 02:39:38
> Committer: Linus Torvalds <torvalds@linux-foundation.org>  2008-08-15 10:34:07
> Parent: 000b9151d7851cc1e490b2a76d0206e524f43cca (Fix race/oops in tty layer after BKL pushdown)
> Branches: git-cifs, git-ia64, git-nfs, git-powerpc-merge, linux-next, remotes/origin/master
> Follows: v2.6.27-rc3
> Precedes: next-20080818
> 
>     tty: remove resize window special case
> 
> perhaps you're still running a kernel which is earlier than that?

I reported the behaviour on 2.6.26.2, but I was not aware this issue was
adressed already in the 2.6.27 tree. I will update to the latest 2.6.27
rc and report if the problem still persists.

