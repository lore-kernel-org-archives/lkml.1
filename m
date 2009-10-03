Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZJCJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZJCJBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 05:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZJCJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 05:01:32 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:44016 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZJCJBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 05:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EYhkmTncmbhxf/S2Osl6AKjbEhqTVT3tqDG89zHkEL4UqDKXwvFSKqln3Ku1gGsDkB
         sPztbOeLrUC1GnPkwF94IXvzS3+YuyzX4BPZE3aM38ULUAWuSa9l99zxA7Xx5M/MgnMM
         qj6hO/2h5LBtT9rXXLJ6lYC1jLOUrfEm85HPk=
MIME-Version: 1.0
In-Reply-To: <20091003072540.GW31616@kernel.dk>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk>
	 <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <20091003072021.GB21407@elte.hu> <20091003072540.GW31616@kernel.dk>
Date: Sat, 3 Oct 2009 11:01:35 +0200
Message-ID: <4e5e476b0910030201k23760da4ke7d6d08662382cf1@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
On Sat, Oct 3, 2009 at 9:25 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Sat, Oct 03 2009, Ingo Molnar wrote:
>>
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>> >     unsigned int cfq_desktop;
>> > +   unsigned int cfq_desktop_dispatch;
>>
>> > -   if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
>> > +   if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC]) {
>> > +           cfqd->desktop_dispatch_ts = jiffies;
>> >             return 0;
>> > +   }
>>
>> btw., i hope all those desktop_ things will be named latency_ pretty
>> soon as the consensus seems to be - the word 'desktop' feels so wrong in
>> this context.
>>
>> 'desktop' is a form of use of computers and the implication of good
>> latencies goes far beyond that category of systems.
>
> I will rename it, for now it doesn't matter (lets not get bogged down in
> bike shed colors, please).
>
> Oh and Mike, I forgot to mention this in the previous email - no more
> tunables, please. We'll keep this under a single knob.

Did you have a look at my http://patchwork.kernel.org/patch/47750/ ?
It already introduces a 'target_latency' tunable, expressed in ms.

If we can quantify the benefits of each technique, we could enable
them based on the target latency requested by that single tunable.

Corrado

>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
