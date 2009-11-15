Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZKORbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZKORbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 12:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZKORbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 12:31:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1071 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZKORbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 12:31:35 -0500
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, julia Lawall <julia@diku.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091115103307.GB24931@elte.hu>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	 <20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	 <1258273714.21668.13.camel@Joe-Laptop.home>
	 <20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org>
	 <20091115103307.GB24931@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Nov 2009 09:31:39 -0800
Message-ID: <1258306299.21668.30.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 11:33 +0100, Ingo Molnar wrote:
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > > * Joe Perches <joe@perches.com> wrote:
> > >> On Sun, 2009-11-15 at 09:11 +0100, Ingo Molnar wrote:
> > >> > * Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
> > >> > > On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
> > >> > > >Seems to be a typo.
> > >> > > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> > >> > (Cc:-ed Eric who is running the sysctl tree these days)
> > >> > Almost everywhere in the kernel we use the shorter version, so all of 
> > >> > sysctl.c should eventually change to that variant.
> > >> It's closer to 50/50, but it's 1 vs 133 in that file.
> > >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*&\s*\w+' * | wc -l
> > >> 339
> > >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*[^&]\s*\w+' * | wc -l
> > >> 432
> > > I did not mean this specific initialization method of proc_handler, i 
> > > meant pointers to functions in general.
> > There was an argument put forward by Alexy (I think) a while ago.  
> > That argued for the form without the address of operator.
> > The reason being that without it you can do:
> > #define proc_dointvec NULL
> > in a header when sysctl support it compiled out.  Using address of
> > you wind up with stub functions in sysctl.c to handle the case when
> > sysctl is compiled out.
> > It isn't a strong case but since not using & is also shorter and as 
> > Ingo pointed out more common I think no & wins.
> I can think of another reason as well: the & operator can be dangerous 
> if code is changed from functions to function pointers.
> 
> The short form:
> 
>   val = do_my_func;
> 
> will work just fine if 'my_func' is changed to a function pointer, as it 
> will evaluate to the value of the function pointer - i.e. the address of 
> the function.
> 
> The longer form:
> 
>   val = &do_my_func;
> 
> might break in a subtle way, because it will now become the address of 
> the function pointer - not the function address.
> 
> Combined the shortness, the NULL init, the function pointer invariance, 
> plus existing in-kernel practice all suggest that the short form should 
> be used.
> 
> ( i didnt want to turn this small issue into a long argument - it's just
>   that the code was going in the wrong direction. )

That sounds like something coccinelle would do well,
so I've cc'd Julia Lawall.

http://lkml.org/lkml/2009/11/15/55

