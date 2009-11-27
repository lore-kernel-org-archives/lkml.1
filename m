Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZK0HIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZK0HIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZK0HIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:08:14 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61173 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZK0HIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:08:14 -0500
MIME-Version: 1.0
In-Reply-To: <661de9470911261908i4bb51e91v649025e6c75bd91b@mail.gmail.com>
References: <cover.1259255307.git.kirill@shutemov.name>
	 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259255307.git.kirill@shutemov.name>
	 <8524ba285f6dd59cda939c28da523f344cdab3da.1259255307.git.kirill@shutemov.name>
	 <20091127092035.bbf2efdc.nishimura@mxp.nes.nec.co.jp>
	 <20091127114511.bbb43d5a.kamezawa.hiroyu@jp.fujitsu.com>
	 <661de9470911261908i4bb51e91v649025e6c75bd91b@mail.gmail.com>
Date: Fri, 27 Nov 2009 09:08:19 +0200
Message-ID: <cc557aab0911262308h452e836fo94c11c2d051e98a0@mail.gmail.com>
Subject: Re: [PATCH RFC v0 2/3] res_counter: implement thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 5:08 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Fri, Nov 27, 2009 at 8:15 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Fri, 27 Nov 2009 09:20:35 +0900
>> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
>>
>>> Hi.
>>> >
>>> > @@ -73,6 +76,7 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>>> >             val = counter->usage;
>>> >
>>> >     counter->usage -= val;
>>> > +   res_counter_threshold_notify_locked(counter);
>>> >  }
>>> >
>>> hmm.. this adds new checks to hot-path of process life cycle.
>>>
>>> Do you have any number on performance impact of these patches(w/o setting any threshold)?

No, I don't. I did only functional testing on this stage.

>>> IMHO, it might be small enough to be ignored because KAMEZAWA-san's coalesce charge/uncharge
>>> patches have decreased charge/uncharge for res_counter itself, but I want to know just to make sure.
>>>
>> Another concern is to support root cgroup, you need another notifier hook in
>> memcg because root cgroup doesn't use res_counter now.
>>
>> Can't this be implemented in a way like softlimit check ?

I'll investigate it.

>> Filter by the number of event will be good for notifier behavior, for avoiding
>> too much wake up, too.

Good idea, thanks.

> I guess the semantics would vary then, they would become activity
> semantics. I think we should avoid threshold notification for root,
> since we have no limits in root anymore.

Threshold notifications for root cgroup is really needed on embedded
systems to avid OOM-killer.

>
> BTW, Kirill, I've been meaning to write this layer on top of
> cgroupstats, is there anything that prevents us from using that today?

I'll investigate it.

> CC'ing Dan Malek and Vladslav Buzov who worked on similar patches
> earlier.
>
> Balbir Singh.
>
