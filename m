Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZKON5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZKON5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 08:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZKON5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 08:57:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZKON5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 08:57:12 -0500
Date: Sun, 15 Nov 2009 14:57:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Perches <joe@perches.com>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
Message-ID: <20091115135705.GA9329@elte.hu>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
 <20091115065958.GA2459@hack>
 <20091115081126.GD15432@elte.hu>
 <1258273714.21668.13.camel@Joe-Laptop.home>
 <20091115083951.GA27393@elte.hu>
 <m1hbswm7dk.fsf@fess.ebiederm.org>
 <20091115103307.GB24931@elte.hu>
 <m11vk0m0np.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vk0m0np.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >> Ingo Molnar <mingo@elte.hu> writes:
> >> 
> >> > * Joe Perches <joe@perches.com> wrote:
> >> >
> >> >> On Sun, 2009-11-15 at 09:11 +0100, Ingo Molnar wrote:
> >> >> > * Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
> >> >> > > On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
> >> >> > > >Seems to be a typo.
> >> >> > > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> >> >> > (Cc:-ed Eric who is running the sysctl tree these days)
> >> >> > Almost everywhere in the kernel we use the shorter version, so all of 
> >> >> > sysctl.c should eventually change to that variant.
> >> >> 
> >> >> It's closer to 50/50, but it's 1 vs 133 in that file.
> >> >> 
> >> >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*&\s*\w+' * | wc -l
> >> >> 339
> >> >> 
> >> >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*[^&]\s*\w+' * | wc -l
> >> >> 432
> >> >
> >> > I did not mean this specific initialization method of proc_handler, i 
> >> > meant pointers to functions in general.
> >> 
> >> 
> >> There was an argument put forward by Alexy (I think) a while ago.  
> >> That argued for the form without the address of operator.
> >> 
> >> The reason being that without it you can do:
> >> #define proc_dointvec NULL
> >> 
> >> in a header when sysctl support it compiled out.  Using address of
> >> you wind up with stub functions in sysctl.c to handle the case when
> >> sysctl is compiled out.
> >> 
> >> It isn't a strong case but since not using & is also shorter and as 
> >> Ingo pointed out more common I think no & wins.
> >
> > I can think of another reason as well: the & operator can be dangerous 
> > if code is changed from functions to function pointers.
> >
> > The short form:
> >
> >   val = do_my_func;
> >
> > will work just fine if 'my_func' is changed to a function pointer, as it 
> > will evaluate to the value of the function pointer - i.e. the address of 
> > the function.
> >
> > The longer form:
> >
> >   val = &do_my_func;
> >
> > might break in a subtle way, because it will now become the address of 
> > the function pointer - not the function address.
> >
> > Combined the shortness, the NULL init, the function pointer invariance, 
> > plus existing in-kernel practice all suggest that the short form should 
> > be used.
> >
> > ( i didnt want to turn this small issue into a long argument - it's just
> >   that the code was going in the wrong direction. )
> 
> No problem here.  I'm still working through how to keep my tree from 
> conflicting with the net tree, big sweeping tend to have that problem, 
> but if someone wants to generate the & removal patches (against my 
> tree) and send them to me I will be happy to host them.  I am already 
> touching practically every sysctl table in the tree.

The preferred flow is for you to just work against Linus's latest tree - 
and everyone will deal with the (mostly trivial) conflicts when they 
happen. Linus prefers to resolve conflicts himself when he pulls, 
because people mixing their trees (such as you basing on net-next for 
example) leads to various dependency problems.

	Ingo
