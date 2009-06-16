Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZFPSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZFPSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZFPSY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:24:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47448 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZFPSY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:24:57 -0400
Date: Tue, 16 Jun 2009 20:24:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Rottinger <steve@pentek.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC][PATCH] add support for shrinking/growing a pipe (Was "Re:
	splice methods in character device driver")
Message-ID: <20090616182459.GC11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com> <20090616115917.GX11363@kernel.dk> <4A37B4D8.5090404@pentek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37B4D8.5090404@pentek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16 2009, Steve Rottinger wrote:
> >> Although,  I think that most of the overhead that I was experiencing
> >> came from the cumulative
> >> overhead of each splice system call.   I increased my pipe size using
> >> Jens' pipe size patch,
> >> from 16 to 256 pages, and this had a huge effect -- the speed of my
> >> transfers more than doubled.
> >> Pipe sizes larger that 256 pages, cause my kernel to crash.
> >>     
> >
> > Yes, the system call is more expensive. Increasing the pipe size can
> > definitely help there.
> >
> >   
> I know that you have been asked this before, but is there any chance
> that we can
> get the pipe size patch into the kernel mainline?  It seems like it is
> essential to
> moving data fast using the splice interface.

Sure, the only unresolved issue with it is what sort of interface to
export for changing the pipe size. I went with fcntl().

Linus, I think we discussed this years ago. The patch in question is
here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=24547ac4d97bebb58caf9ce58bd507a95c812a3f

I'd like to get it in now, there has been several requests for this in
the past. But I didn't want to push it before this was resolved.

I don't know whether other operating systems allow this functionality,
and if they do what interface they use. I suspect that our need is
somewhat special, since we have splice.

-- 
Jens Axboe

