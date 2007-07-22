Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbXGVUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbXGVUlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbXGVUln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:41:43 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:37014 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762714AbXGVUlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:41:42 -0400
Date: Mon, 23 Jul 2007 05:41:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jan Dittmer <jdi@l4x.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
Message-ID: <20070722204110.GA12101@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jan Dittmer <jdi@l4x.org>, linux-kernel@vger.kernel.org
References: <20070720091707.GA26717@linux-sh.org> <46A0C199.8050401@l4x.org> <20070720151543.GA28274@linux-sh.org> <46A33D03.3000105@l4x.org> <20070722114253.GA11519@linux-sh.org> <46A3882C.7040709@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A3882C.7040709@l4x.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 06:39:08PM +0200, Jan Dittmer wrote:
> Paul Mundt wrote:
> > On Sun, Jul 22, 2007 at 01:18:27PM +0200, Jan Dittmer wrote:
> >> 2.17.50.0.17.20070615 and gcc 4.1.3 20070704 (prerelease) to compile
> >> (supplying it with uclibc- and lk-headers). But compiling 2.6.22-git17
> >> now fails with
> >>
> >>   CC      drivers/video/cfbimgblt.o
> >>   CC      drivers/video/fb_defio.o
> >>   LD      drivers/video/built-in.o
> >>   LD      drivers/built-in.o
> >> sh64-linux-ld: sh3 architecture of input file `drivers/media/built-in.o'
> >> is incompatible with sh5 output
> >> sh64-linux-ld: sh3 architecture of input file `drivers/i2c/built-in.o'
> >> is incompatible with sh5 output
> >> make[2]: *** [drivers/built-in.o] Error 1
> >> make[1]: *** [drivers] Error 2
> >> make: *** [_all] Error 2
> >>
> >> Known?
> >>
> > It's known that empty objects require explicit tuning for the ABI,
> > however, this has never been anything that was fatal. If you flip
> > something on within each of those subsystems, does the error go away?
> 
> Yes, thanks this fixes it. Would you accept a patch to modify the
> defconfig so that it builds by default? Would be most useful for
> my pet project (http://l4x.org/k/). A fixed toolchain would of course
> also be nice.
> 
I'll certainly apply patches that help getting it building, so feel free
to send updates for that. As I also noted, the empty object thing is
non-fatal with my toolchain, so I'd also appreciate it if you could put
a tarball of yours up somewhere so this is a bit easier to verify. I
suspect this is just something we're going to have to change in binutils,
however.
