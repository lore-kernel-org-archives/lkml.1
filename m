Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXFDTq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXFDTq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761897AbXFDTqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:46:06 -0400
Received: from pat.uio.no ([129.240.10.15]:54933 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761682AbXFDTqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:46:04 -0400
Subject: Re: slow open() calls and o_nonblock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Aaron Wiebe <epiphani@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e7ca40f70706040926i737cc0dax3f35d89e9fb0104f@mail.gmail.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
	 <1180971726.17737.36.camel@heimdal.trondhjem.org>
	 <e7ca40f70706040859g323d813fy3d7e741de8f190dc@mail.gmail.com>
	 <e7ca40f70706040926i737cc0dax3f35d89e9fb0104f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 15:46:00 -0400
Message-Id: <1180986360.6657.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.088)
X-UiO-Scanned: C0A201EDEEAEB392FADF68F1B0091529C5CB45F9
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 836 total 2158750 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 12:26 -0400, Aaron Wiebe wrote:
> Actually, lets see if I can summarize this more generically... I
> realize I'm suggesting something that probably would be a massive
> undertaking, but ..
> 
> Regular files are the only interface that requires an application to
> wait.  With any other case, the nonblocking interfaces are fairly
> complete and easy to work with.  If userspace could treat regular
> files in the same fashion as sockets, life would be good.
> 
> I admittedly do not understand internal kernel semantics in the
> differences between a socket and a regular file.  Why couldn't we just
> have a different 'socket type' like PF_FILE or something like this?
> 
> Abstracting any IO through the existing interfaces provided to sockets
> would be ideal from my perspective.  The code required to use a file
> through these interfaces would be more complex in userspace, but the
> abstraction of the current open() itself could simply be an aggregate
> of these interfaces without a nonblocking flag.
> 
> It would, however, fix problems around issues with event-based
> applications handling events from both disk and sockets.  I can't
> trigger disk read/write events in the same event handlers I use for
> sockets (ie, poll or epoll).  I end up having two separate event
> handlers - one for disk (currently using glibc's aio thread kludge),
> and one for sockets.
> 
> I'm sure this isn't a new idea.  Coming from my own development
> backround that had little to do with disk, I was actually surprised
> when I first discovered that I couldn't edge-trigger disk IO through
> poll().
> 
> Thoughts, comments?

Unless you're planning on rearchitecting the entire VFS lookup and
permissions code, you would basically have to fall back onto having a
pool of service threads actually perform the I/O. That can just as
easily be done today in userland.

AFAICS, syslets should give you the means to implement a more scalable
scheme, but we'll have to wait and see if/when those are ready for
kernel inclusion.

Cheers
  Trond

