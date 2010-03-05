Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0CESwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:52:08 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:48221 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0CESwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:52:06 -0500
MIME-Version: 1.0
In-Reply-To: <20100304221434.17567187@magilla.sf.frob.com>
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com> 
	<20100304221434.17567187@magilla.sf.frob.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 5 Mar 2010 10:51:47 -0800
Message-ID: <ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 14:14, Roland McGrath <roland@redhat.com> wrote:
>> Security. This is beyond my understanding, hopefully the cc'ed
>> experts can help.
>
> There are a few different aspects of behavior change to think about.
>
> 1. Who can get a SIGCHLD and wait result they weren't expecting.
> 2. Who sees some PID for getppid() when they are expecting 1.
> 3. What ps shows.
>
> When I start thinking through what might be security issues, they are
> almost all #1 questions.  There is a hairy nest of many variations of #1
> questions.  The #2 question is pretty simple, but it also could be an issue
> for security when setuid is involved (or just correctness for any
> application).
>
> My impression is that #3 is the only actual motivation for this feature.
> So perhaps we should consider an approach that leaves the rest of the
> semantics alone and only affects that.

Oh, no. Actually getting the SIGCHILD is the needed feature here. A
process who sets the ANCHOR flag is surely expected to handle these
signals. It's all about a user "init-like" process" that can do
similar things for a logged-in user what /sbin/init can to for the
system. So, it's all about 1.), and 3.) is a nice side-effect, but not
the motivation to do this.

And 2.) is just very broken behavior that should be fixed in the
application, and it can be worked around in the sub-init process if
needed.

Thanks,
Kay
