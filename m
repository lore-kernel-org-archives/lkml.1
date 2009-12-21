Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZLUMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZLUMQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZLUMQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:16:21 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57312 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZLUMQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:16:20 -0500
Date: Mon, 21 Dec 2009 13:16:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, nauman@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, Alan.Brunelle@hp.com
Subject: Re: [RFC] CFQ group scheduling structure organization
Message-ID: <20091221121619.GJ4489@kernel.dk>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com> <4B2AC59D.2010004@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2AC59D.2010004@ds.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17 2009, Munehiro Ikeda wrote:
> Hello,
>
> Corrado Zoccolo wrote, on 12/17/2009 06:41 AM:
>> Hi,
>> On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal<vgoyal@redhat.com>  wrote:
>>> Hi All,
>>>
>>> With some basic group scheduling support in CFQ, there are few questions
>>> regarding how group structure should look like in CFQ.
>>>
>>> Currently, grouping looks as follows. A, and B are two cgroups created by
>>> user.
>>>
>>> [snip]
>>>
>>> Proposal 4:
>>> ==========
>>> Treat task and group at same level. Currently groups are at top level and
>>> at second level are tasks. View the whole hierarchy as follows.
>>>
>>>
>>>                         service-tree
>>>                         /   |  \  \
>>>                        T1   T2  G1 G2
>>>
>>> Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
>>> created under root.
>>>
>>> In this kind of scheme, any RT task in root group will still be system
>>> wide RT even if we create groups G1 and G2.
>>>
>>> So what are the issues?
>>>
>>> - I talked to few folks and everybody found this scheme not so intutive.
>>>   Their argument was that once I create a cgroup, say A,  under root, then
>>>   bandwidth should be divided between "root" and "A" proportionate to
>>>   the weight.
>>>
>>>   It is not very intutive that group is competing with all the tasks
>>>   running in root group. And disk share of newly created group will change
>>>   if more tasks fork in root group. So it is highly dynamic and not
>>>   static hence un-intutive.
>
> I agree it might be dynamic but I don't think it's un-intuitive.
> I think it's reasonable that disk share of a group is
> influenced by the number of tasks running in root group,
> because the root group is shared by the tasks and groups from
> the viewpoint of cgroup I/F, and they really share disk bandwidth.

Agree, this is my preferred solution as well. There are definitely valid
cases for both doing system wide RT and system wide idle, and there are
definitely valid reasons for doing that inside a single group as well.

-- 
Jens Axboe

