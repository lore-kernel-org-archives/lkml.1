Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYDTQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYDTQmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYDTQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:42:12 -0400
Received: from lazybastard.de ([212.112.238.170]:56572 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYDTQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:42:12 -0400
Date: Sun, 20 Apr 2008 18:41:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420164133.GB20694@logfs.org>
References: <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480B50F1.8040309@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 April 2008 16:19:29 +0200, Andi Kleen wrote:
> 
> Only if you believe that 4K stack pages are a worthy goal.
> As far as I can figure out they are not. They might have been
> a worthy goal on crappy 2.4 VMs, but these times are long gone.
> 
> The "saving memory on embedded" argument also does not 
> quite convince me, it is unclear if that is really
> a significant amount of memory on these systems and if that 
> couldn't be addressed better (e.g. in running generally
> less kernel threads).  I don't have numbers on this,
> but then the people who made this argument didn't have any
> either :) 

It is not uncommon for embedded systems to be designed around 16MiB.
Some may even have less, although I haven't encountered any of those
lately.

When dealing in those dimensions, savings of 100k are substantial.  In
some causes they may be the difference between 16MiB or 32MiB, which
translates to manufacturing costs.  In others it simply means that the
system can cache a bit more and run faster, or it can have a little more
functionality.

In most cases it simply allows userspace programmers to avoid looking
harder to save those 100k, as they are already saved in kernel space.
Therefore we made life hard for us in order to make life easier for
someone else, saving them time and money.

Whether that is worth it depends on your personal point of view.  Many
embedded people will claim "Hell yes!"  Of those that don't, most are
simply ignoring currently mainline kernels and will regret the
development later.  They care, thay just don't tend to care enough to
engage in these discussions or even know about them. :(

Jörn

-- 
Eighty percent of success is showing up.
-- Woody Allen
