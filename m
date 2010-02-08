Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab0BHHLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:11:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43067 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0BHHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:11:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Neuling <mikey@neuling.org>,
       Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
In-Reply-To: <2375c9f91002072307h4af1ba6dw1b7a598582991dc4@mail.gmail.com>
References: <20100208145240.FB58.A69D9226@jp.fujitsu.com> <2375c9f91002072307h4af1ba6dw1b7a598582991dc4@mail.gmail.com>
Message-Id: <20100208161014.7C6D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Feb 2010 16:11:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 8, 2010 at 2:05 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> --- linux-2.6-ozlabs.orig/fs/exec.c
> >> +++ linux-2.6-ozlabs/fs/exec.c
> >> @@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm
> >>                       goto out_unlock;
> >>       }
> >>
> >> +     stack_base = min(EXTRA_STACK_VM_PAGES * PAGE_SIZE,
> >> +                      current->signal->rlim[RLIMIT_STACK].rlim_cur -
> >> +                        PAGE_SIZE);
> >
> > This line is a bit unclear why "- PAGE_SIZE" is necessary.
> > personally, I like following likes explicit comments.
> >
> >        stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> >        stack_lim = ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur);
> >
> >        /* Initial stack must not cause stack overflow. */
> >        if (stack_expand + PAGE_SIZE > stack_lim)
> >                stack_expand = stack_lim - PAGE_SIZE;
> >
> > note: accessing rlim_cur require ACCESS_ONCE.
> >
> >
> > Thought?
> 
> It's better to use the helper function: rlimit().

AFAIK, stable tree doesn't have rlimit(). but yes, making two patch
(for mainline and for stable) is good opinion.



