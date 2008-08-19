Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYHSHye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYHSHye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYHSHy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:54:26 -0400
Received: from pruts.nl ([82.94.235.106]:56218 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYHSHyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:54:25 -0400
Date: Tue, 19 Aug 2008 09:54:14 +0200
From: Ico Doornekamp <lkml@zevv.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080819075414.GV29842@pruts.nl>
References: <20080810150859.GO3653@pruts.nl> <20080819004026.2dac3ba6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819004026.2dac3ba6.akpm@linux-foundation.org>
X-Prutser: true
X-PGP-key: 4202FA2F
X-PGP-KeyServer: subkeys.pgp.net
X-PGP-Fingerprint: F042 F5CD B0A6 EC6A CB80  A829 CACD A4B5 4202 FA2F
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :

> On Sun, 10 Aug 2008 17:08:59 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> 
> > Recently my X terminals showed annoying behaviour where the application
> > in the terminal was not resized properly to the actual size of the X
> > terminal emulator window, resulting in a lot of misaligned text on the
> > screen. Hunting the issue down from the windowmanager and the terminal
> > emulator program, I suspect the problem might lie in the kernel. I'm
> > running 2.6.26 on a dual core i386.
> > 
> > What I see is this: the userspace application receives a SIGWINCH signal
> > and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
> > in some cases the old instead of the new terminal size is returned.
> > A small delay before the ioctl seems to 'fix' this behaviour.
> > 
> > I noticed some changes involving locking in the the pty code in the last
> > kernel verions, could one of these changes cause the above behaviour ? If
> > so, wouldn't this affect much more users ?
> 
> hm, that code is pretty simple and although it does the SIGWINCH and
> the window-size setting in a peculiar order, it looks to be race-free.
> 
> Approximately what proportion of the time does it go wrong?

I guess about 10 to 20% of the resizes. I happen to be using a tiling
window manager which causes resizing more often and more agressive then
'normal' window managers, I guess this helps triggering the problem.

I temporary worked around this issue this by changing the order of the
signal and the updating of the pty size in tty_io.c's tiocswinsz(), but
this is not much of a real fix.

Ico

