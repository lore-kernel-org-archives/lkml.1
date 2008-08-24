Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYHXHXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYHXHXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYHXHXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 03:23:43 -0400
Received: from bu3sch.de ([62.75.166.246]:43880 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYHXHXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 03:23:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: benh@kernel.crashing.org
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
Date: Sun, 24 Aug 2008 09:23:08 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
References: <200808231610.46473.mb@bu3sch.de> <1219531969.21386.205.camel@pasglop>
In-Reply-To: <1219531969.21386.205.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240923.09083.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2008 00:52:49 Benjamin Herrenschmidt wrote:
> On Sat, 2008-08-23 at 16:10 +0200, Michael Buesch wrote:
> > I am seeing random kernel and userland application
> > crashes on a Powerbook running a 2.6.27-rc3 based kernel (wireless-testing.git).
> > 
> > The crashes did recently appear. It might be the case that they were
> > introduced with the merge of 2.6.27-rc1 into wireless-testing.
> > I'm not sure on that one, however. Just a guess. I still need to
> > do more testing (also on vanilla upstream kernels).
> > 
> > The crashes are completely random and they look like bad hardware.
> > However I cannot reproduce on 2.6.25.9 (That's a kernel I still had
> > installed, so I tried that one). So it most likely is _not_ caused
> > by faulty hardware.
> > 
> > The crashes are hard to reproduce, and happen about every 20 minutes
> > when compiling a kernel tree. (gcc segfaults). Sometimes the kernel
> > oopses in random places with pointer dereference faults.
> > 
> > Is this a known issue?
> > I'm going to bisect this one, but it will take a lot of time, as reproducing
> > takes about 20 minutes. So that's about an hour for one test round.
> > 
> > The kernel configuration is the following:
> 
> Random guess:
> 
> CONFIG_FRAME_POINTER=y
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> 
> Note sure what those together do, check if you have any file compiled
> with -fno-omit-frame-pointer and if you do, try to change things so
> that you don't ... we found some miscompiles when that is set, exposed
> by FTRACE typically (which you don't have enabled) but possibly by other
> things.


Ok, thanks for the suggestion.
I could reproduce the crash with 2.6.26, so this is not a regression between
2.6.26 and 2.6.27-rcX.
I'm currently running longer tests on 2.6.25 again to make sure it really
isn't hardware related.


NO_NO_OMIT is a brain screwer, btw :)

-- 
Greetings Michael.
