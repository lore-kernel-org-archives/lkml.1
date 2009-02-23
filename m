Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZBWNAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZBWNAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZBWM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:59:58 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55889 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZBWM75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:59:57 -0500
To: catalin.marinas@arm.com
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: How to analyze kmemleak message?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
	<84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
	<1235385947.14987.41.camel@pc1117.cambridge.arm.com>
	<200902232029.HGI04666.FLOOFSVFJtHQMO@I-love.SAKURA.ne.jp>
	<1235391634.14987.61.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1235391634.14987.61.camel@pc1117.cambridge.arm.com>
Message-Id: <200902232159.DBJ26012.JHFSMVOOQtFFLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 23 Feb 2009 21:59:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Catalin Marinas wrote:
> On Mon, 2009-02-23 at 20:29 +0900, Tetsuo Handa wrote:
> >   void *p1;
> >   
> >   void foo(void)
> >   {
> >       void *p2 = kmalloc(1, GFP_KERNEL);
> >       p1 = kmalloc(1, GFP_KERNEL);
> >   }
> > 
> > "p1" will be reported by default.
> 
> p1 won't be reported as a leak because it is a global variable and the
> data section is scanned.
> 
I see.

> > To report "p2", we need to write "stack=on" to /sys/kernel/debug/kmemleak .
> 
> It's the opposite - p2 will be reported as leak by default (stack=off)
> unless you enable the stack scanning (stack=on).
>
I see.

> I don't think you need to do anything here. Since p is a static local
> variable, isn't it placed in a data section somewhere (and automatically
> scanned by kmemleak)?
>
I see.

After all, I have nothing to modify for kmemleak. All I need to do is
"Just turn on kmemleak and see if functions in my module are reported or not".

Thank you.
