Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXJDNJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXJDNJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 09:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJDNJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 09:09:03 -0400
Received: from aun.it.uu.se ([130.238.12.36]:44178 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbXJDNJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 09:09:00 -0400
Date: Thu, 4 Oct 2007 15:08:35 +0200 (MEST)
Message-Id: <200710041308.l94D8ZZD015983@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: kamezawa.hiroyu@jp.fujitsu.com, shiwh@cn.fujitsu.com
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound occurs
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 21:47:30 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 04 Oct 2007 21:33:12 +0900
> Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> 
> > KAMEZAWA Hiroyuki wrote::
> > > On Thu, 04 Oct 2007 20:56:14 +0900
> > > Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> > > 
> > >> 	stack.ss_sp = addr + pagesize;
> > >> 	stack.ss_flags = 0;
> > >> 	stack.ss_size = pagesize;
> > > Here is bad. 
> > > stack,ss_sp = addr;
> > > stack.ss_flags = 0;
> > > stack.ss_size = pagesize * 2;
> > [What the test code want to do]
> > addr+pagesize*2 - addr+pagesize	 -> sigaltstack
> > addr+pagesize	- addr		 -> protected region
> > The code want to catch overflow when esp enter the protected region.
> > 
> You have to protect the top of *registered* sigaltstack.
> The reason of wraparound is %esp will be set to the bottom of sigaltstack
> if it is not on sigaltstack area when signaled.
> What you have to do is protect the top of registerd sigaltstack.
> If %esp is in the range of registerd sigaltstack at SEGV, wraparound
> will stop.

Exactly right. You mprotect or munmap the end of the altstack,
not the area beyond it.

/Mikael
