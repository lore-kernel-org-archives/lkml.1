Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab0BJFNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 00:13:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36698 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0BJFM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 00:12:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] Restrict initial stack space expansion to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Neuling <mikey@neuling.org>,
       Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <4B71E13C.2050905@gmx.de>
References: <10733.1265752289@neuling.org> <4B71E13C.2050905@gmx.de>
Message-Id: <20100210141016.4D18.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Feb 2010 14:12:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/09/2010 10:51 PM, Michael Neuling wrote:
> >>> I'd still like someone with a CONFIG_STACK_GROWSUP arch to test/ACK it
> >>> as well.
> >>
> >> There's only one CONFIG_GROWSUP arch - parisc.
> >> Could someone please test it on parisc?
> 
> I did.
> 
> > How about doing:
> >    'ulimit -s 15; ls'
> > before and after the patch is applied.  Before it's applied, 'ls' should
> > be killed.  After the patch is applied, 'ls' should no longer be killed.
> >
> > I'm suggesting a stack limit of 15KB since it's small enough to trigger
> > 20*PAGE_SIZE.  Also 15KB not a multiple of PAGE_SIZE, which is a trickier
> > case to handle correctly with this code.
> >
> > 4K pages on parisc should be fine to test with.
> 
> Mikey, thanks for the suggested test plan.
> 
> I'm not sure if your patch does it correct for parisc/stack-grows-up-case.
> 
> I tested your patch on  a 4k pages kernel:
> root@c3000:~# uname -a
> Linux c3000 2.6.33-rc7-32bit #221 Tue Feb 9 23:17:06 CET 2010 parisc GNU/Linux
> 
> Without your patch:
> root@c3000:~# ulimit -s 15; ls
> Killed
> -> correct.
> 
> With your patch:
> root@c3000:~# ulimit -s 15; ls
> Killed
> _or_:
> root@c3000:~# ulimit -s 15; ls
> Segmentation fault
> -> ??
> 
> Any idea?

My x86_64 box also makes segmentation fault. I think "ulimit -s 15" is too small stack for ls.
"ulimit -s 27; ls "  wroks perfectly fine.



