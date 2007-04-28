Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXD1Gci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXD1Gci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbXD1Gch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:32:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:56631 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756111AbXD1Gcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:32:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1UtgayW21Lq6sjSBaaIrKWFZPSOp+4V16kX81f6
	tFi8nD0eQR9vRM
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1177734305.6266.7.camel@Homer.simpson.net>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	 <1177734305.6266.7.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 08:32:32 +0200
Message-Id: <1177741953.6268.18.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 06:25 +0200, Mike Galbraith wrote:
> On Fri, 2007-04-27 at 08:18 -0700, Linus Torvalds wrote:
> 
> > Actually, you don't need to apply the patch - just do
> > 
> > 	echo 5 > /proc/sys/vm/dirty_background_ratio
> > 	echo 10 > /proc/sys/vm/dirty_ratio
> 
> That seems to have done the trick.  Amarok and GUI aren't exactly speed
> demons while writeout is happening, but they are not hanging for
> eternities.

As promised, I tested with a kernel that I know for fact that I have
tested heavy IO on previously, and behavior was identically horrid, so
it's not something new that snuck in ~recently, my disk just got a _lot_
fuller in the meantime (12k mp3s munch a lot).

I also verified that I don't need to use the dirty data restrictions
with ext2, all is just peachy using stock settings.  Amarok switches
songs quickly, and GUI doesn't hang.  Behavior is that expected of a
heavily loaded IO subsystem, and is 1000% better than ext3 with my very
full disk.

Journaling is very nice, but I think I'll be much better off without it
responsiveness wise.

	-Mike

