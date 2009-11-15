Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZKOM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZKOM3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZKOM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:29:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47767 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZKOM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:29:31 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to &proc_dointvec,
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	<20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	<1258273714.21668.13.camel@Joe-Laptop.home>
	<20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org>
	<20091115103307.GB24931@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 15 Nov 2009 04:29:30 -0800
In-Reply-To: <20091115103307.GB24931@elte.hu> (Ingo Molnar's message of "Sun\, 15 Nov 2009 11\:33\:07 +0100")
Message-ID: <m11vk0m0np.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > * Joe Perches <joe@perches.com> wrote:
>> >
>> >> On Sun, 2009-11-15 at 09:11 +0100, Ingo Molnar wrote:
>> >> > * Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
>> >> > > On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
>> >> > > >Seems to be a typo.
>> >> > > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>> >> > (Cc:-ed Eric who is running the sysctl tree these days)
>> >> > Almost everywhere in the kernel we use the shorter version, so all of 
>> >> > sysctl.c should eventually change to that variant.
>> >> 
>> >> It's closer to 50/50, but it's 1 vs 133 in that file.
>> >> 
>> >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*&\s*\w+' * | wc -l
>> >> 339
>> >> 
>> >> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*[^&]\s*\w+' * | wc -l
>> >> 432
>> >
>> > I did not mean this specific initialization method of proc_handler, i 
>> > meant pointers to functions in general.
>> 
>> 
>> There was an argument put forward by Alexy (I think) a while ago.  
>> That argued for the form without the address of operator.
>> 
>> The reason being that without it you can do:
>> #define proc_dointvec NULL
>> 
>> in a header when sysctl support it compiled out.  Using address of
>> you wind up with stub functions in sysctl.c to handle the case when
>> sysctl is compiled out.
>> 
>> It isn't a strong case but since not using & is also shorter and as 
>> Ingo pointed out more common I think no & wins.
>
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

No problem here.  I'm still working through how to keep my tree from
conflicting with the net tree, big sweeping tend to have that problem,
but if someone wants to generate the & removal patches (against my
tree) and send them to me I will be happy to host them.  I am already
touching practically every sysctl table in the tree.

Eric


