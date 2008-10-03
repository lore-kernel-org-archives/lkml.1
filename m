Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYJCKku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYJCKku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYJCKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:40:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:34924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYJCKkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:40:43 -0400
Subject: Re: [PATCH] printk.caller
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081002163154.fd5f2a10.akpm@linux-foundation.org>
References: <20081002232115.8D2BB154212@magilla.localdomain>
	 <20081002163154.fd5f2a10.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 12:40:41 +0200
Message-Id: <1223030441.28938.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 16:31 -0700, Andrew Morton wrote:
> On Thu,  2 Oct 2008 16:21:15 -0700 (PDT)
> Roland McGrath <roland@redhat.com> wrote:
> 
> > This adds the printk.caller=[0|1] boot parameter, default setting
> > controlled by CONFIG_PRINTK_CALLER.  (This is modelled on printk.time
> > and CONFIG_PRINTK_TIME.)
> > 
> > When this is set, each printk line is automagically prefixed with
> > "{0x123abc} " giving the PC address of that printk call (actually
> > the PC address just after the call).
> > 
> > As a kernel hacker, I always hate having to grep for some fragment
> > of a message to find the code that generated it.  But I always have
> > my -g vmlinux handy, so:
> > 	(gdb) info line *(0x123abc - 1)
> > is real handy (it pops the source up in an Emacs buffer).
> > 
> 
> hm.  What do others think?

git grep is usually plenty fast for me, but I guess different people,
different tastes.

Also, I always use addr2line instead of gdb,.. another not-to-the-point
difference ;-)

The only real downside to this patch for me is that it potentially
increases the length of lines which means I;d have to stretch my serial
console window, but I guess others might object to the puny increase in
object size.

Flip a coin.

One tiny nit though:

> +                               char pbuf[sizeof caller * 2 + sizeof "{0x} "];

I thought we did sizeof() in-kernel.

