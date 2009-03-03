Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZCCKmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZCCKmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZCCKmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:42:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54468 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZCCKmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:42:32 -0500
Message-ID: <2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1236073236.18955.46.camel@twins>
References: <49A65455.4030204@cn.fujitsu.com>
    <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
    <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
    <1235645076.4645.4781.camel@laptop>
    <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
    <1235647682.4948.15.camel@laptop>
    <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
    <20090226164509.GB6634@linux.vnet.ibm.com>
    <20090227095856.ef8c1c05.kamezawa.hiroyu@jp.fujitsu.com>
    <20090227012915.GF6634@linux.vnet.ibm.com>
    <20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
    <1236005770.5330.583.camel@laptop>
    <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
    <1236066689.18955.27.camel@twins>
    <d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
    <1236073236.18955.46.camel@twins>
Date: Tue, 3 Mar 2009 19:42:24 +0900 (JST)
Subject: Re: [RFC][PATCH] remove rq->lock from cpuacct cgroup (Was Re:
 [PATCH] cpuacct: add a branch prediction
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       paulmck@linux.vnet.ibm.com, "Bharata B Rao" <bharata.rao@gmail.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra  wrote:
> On Tue, 2009-03-03 at 18:04 +0900, KAMEZAWA Hiroyuki wrote:
>> Peter Zijlstra wrote:
>> > On Tue, 2009-03-03 at 08:42 +0900, KAMEZAWA Hiroyuki wrote:
>> >
>> >> > Furthermore, if you want something like schedule_work_on() for each
>> >> cpu,
>> >> > there's schedule_on_each_cpu().
>> >> >
>> >> It can't pass arguments...Maybe I should use rq->lock here to reset
>> >> other cpu's value.
>> >
>> > Why bother with serializing the reset code at all?
>> >
>>   I don't think reset v.s. read is problem but reset v.s. increment
>>   (read-modify-write) can't be ?
>
> Sure, can be, do we care?
>
If small/easy code allows us to declare "there are any racy case!
and you don't have to check whether you successfully reseted",
it's worth to do I think.

Thanks,
-Kame


