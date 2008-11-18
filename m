Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYKRCDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYKRCDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYKRCDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:03:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYKRCDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:03:12 -0500
Message-ID: <4922224A.5030502@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 10:02:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       Fabio Checconi <fchecconi@gmail.com>, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <20081106153022.215696930@redhat.com> <20081113.180558.519459540419535699.ryov@valinux.co.jp> <20081113155834.GE7542@redhat.com> <af41c7c40811131041t1b8491b6la5574ebe75f89000@mail.gmail.com> <20081113214642.GG7542@redhat.com> <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com> <20081114160525.GE24624@redhat.com> <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com>
In-Reply-To: <20081117142309.GA15564@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Nov 14, 2008 at 02:44:22PM -0800, Nauman Rafique wrote:
>> In an attempt to make sure that this discussion leads to
>> something useful, we have summarized the points raised in this
>> discussion and have come up with a strategy for future.
>> The goal of this is to find common ground between all the approaches
>> proposed on this mailing list.
>>
>> 1 Start with Satoshi's latest patches.
> 
> I have had a brief look at both Satoshi's patch and bfq. I kind of like
> bfq's patches for keeping track of per cgroup, per queue data structures.
> May be we can look there also.
> 
>> 2 Do the following to support propotional division:
>>  a) Give time slices in proportion to weights (configurable
>>  option). We can support both priorities and weights by doing
>>  propotional division between requests with same priorities.
>> 3 Schedule time slices using WF2Q+ instead of round robin.
>>  Test the performance impact (both throughput and jitter in latency).
>> 4 Do the following to support the goals of 2 level schedulers:
>>  a) Limit the request descriptors allocated to each cgroup by adding
>>  functionality to elv_may_queue()
>>  b) Add support for putting an absolute limit on IO consumed by a
>>  cgroup. Such support exists in dm-ioband and is provided by Andrea
>>  Righi's patches too.
> 
> Does dm-iobnd support abosolute limit? I think till last version they did
> not. I have not check the latest version though.
> 

No, dm-ioband still provides weight/share control only. Only Andrea Righi's
patches support absolute limit.

>>  c) Add support (configurable option) to keep track of total disk
>> time/sectors/count
>>  consumed at each device, and factor that into scheduling decision
>>  (more discussion needed here)
>> 5 Support multiple layers of cgroups to align IO controller behavior
>>  with CPU scheduling behavior (more discussion?)
>> 6 Incorporate an IO tracking approach which re-uses memory resource
>> controller code but is not dependent on it (may be biocgroup patches from
>> dm-ioband can be used here directly)
>> 7 Start an offline email thread to keep track of progress on the above
>> goals.
>>
>> Please feel free to add/modify items to the list
>> when you respond back. Any comments/suggestions are more than welcome.
>>

