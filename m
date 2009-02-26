Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZBZMGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZBZMGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZBZMGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:06:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58462 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZBZMG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:06:29 -0500
Message-ID: <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1235647682.4948.15.camel@laptop>
References: <49A6475F.4000502@cn.fujitsu.com>
    <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
    <49A6501B.7040604@cn.fujitsu.com>
    <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
    <49A65455.4030204@cn.fujitsu.com>
    <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
    <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
    <1235645076.4645.4781.camel@laptop>
    <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
    <1235647682.4948.15.camel@laptop>
Date: Thu, 26 Feb 2009 21:06:24 +0900 (JST)
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Bharata B Rao" <bharata.rao@gmail.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote：
> On Thu, 2009-02-26 at 20:17 +0900, KAMEZAWA Hiroyuki wrote:
>> Peter Zijlstra wrote：
>> > On Thu, 2009-02-26 at 19:28 +0900, KAMEZAWA Hiroyuki wrote:
>> >
>> >> Taking hierarchy mutex while reading will make read-side stable.
>> >
>> > We're talking about scheduling here, taking a mutex to stop scheduling
>> > won't work, nor will it be acceptible to use anything that will.
>> >
>> No mutex is necessary, anyway.
>> hierarchy-walker function completely works well under rcu read lock,
>> if small jitter is allowed.
>
> Right, should be doable -- and looking at the code, we have this
> horrible 32 bit exception in there that locks the rq in order to read
> the 64bit value.
>
> Would be grand to get rid of that,. how bad would it be for userspace to
> get the occasionally fubarred value?
>
>From view of user-support saler, if terrible broken value is reported,
it will be user-incident and annoy me(us) ;)

I'd like to get rid of rq->lock, too..Hmm.. some routine like
atomic64_read() can help this ? (But I don't want to use atomic_t here..)

> But aside from that, the cpu controller itself is also summing directly
> up the hierarchy, so cpuacct doing the same doesn't seem odd.
>
I'll post some idea if I can think of something reasonable.
But I tend to hesitate to modify sched.c ;)

Thanks,
-Kame

