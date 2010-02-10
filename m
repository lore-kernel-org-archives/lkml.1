Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0BJFbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 00:31:11 -0500
Received: from ozlabs.org ([203.10.76.45]:48024 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab0BJFbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 00:31:08 -0500
From: Michael Neuling <mikey@neuling.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Helge Deller <deller@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Restrict initial stack space expansion to rlimit
In-reply-to: <20100210141016.4D18.A69D9226@jp.fujitsu.com>
References: <10733.1265752289@neuling.org> <4B71E13C.2050905@gmx.de> <20100210141016.4D18.A69D9226@jp.fujitsu.com>
Comments: In-reply-to KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
   message dated "Wed, 10 Feb 2010 14:12:51 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 10 Feb 2010 16:31:07 +1100
Message-ID: <17323.1265779867@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100210141016.4D18.A69D9226@jp.fujitsu.com> you wrote:
> > On 02/09/2010 10:51 PM, Michael Neuling wrote:
> > >>> I'd still like someone with a CONFIG_STACK_GROWSUP arch to test/ACK it
> > >>> as well.
> > >>
> > >> There's only one CONFIG_GROWSUP arch - parisc.
> > >> Could someone please test it on parisc?
> > 
> > I did.
> > 
> > > How about doing:
> > >    'ulimit -s 15; ls'
> > > before and after the patch is applied.  Before it's applied, 'ls' should
> > > be killed.  After the patch is applied, 'ls' should no longer be killed.
> > >
> > > I'm suggesting a stack limit of 15KB since it's small enough to trigger
> > > 20*PAGE_SIZE.  Also 15KB not a multiple of PAGE_SIZE, which is a trickier
> > > case to handle correctly with this code.
> > >
> > > 4K pages on parisc should be fine to test with.
> > 
> > Mikey, thanks for the suggested test plan.
> > 
> > I'm not sure if your patch does it correct for parisc/stack-grows-up-case.
> > 
> > I tested your patch on  a 4k pages kernel:
> > root@c3000:~# uname -a
> > Linux c3000 2.6.33-rc7-32bit #221 Tue Feb 9 23:17:06 CET 2010 parisc GNU/Li
nux
> > 
> > Without your patch:
> > root@c3000:~# ulimit -s 15; ls
> > Killed
> > -> correct.
> > 
> > With your patch:
> > root@c3000:~# ulimit -s 15; ls
> > Killed
> > _or_:
> > root@c3000:~# ulimit -s 15; ls
> > Segmentation fault
> > -> ??
> > 
> > Any idea?
> 
> My x86_64 box also makes segmentation fault. I think "ulimit -s 15" is too sm
all stack for ls.
> "ulimit -s 27; ls "  wroks perfectly fine.

Arrh.  I asked Helge offline earlier to check what use to work on parisc
on 2.6.31.

I guess PPC has a nice clean non-bloated ABI :-D

Mikey
