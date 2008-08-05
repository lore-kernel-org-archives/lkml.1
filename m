Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYHELTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYHELTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYHELTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:19:00 -0400
Received: from as3.cineca.com ([130.186.84.211]:42720 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYHELTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:19:00 -0400
Message-ID: <48981E03.5020406@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: dave@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
Subject: Re: Too many I/O controller patches
References: <489748E6.5080106@gmail.com>	<1217876521.20260.123.camel@nimitz>	<48976A2A.9060600@gmail.com> <20080805.151642.31467169.taka@valinux.co.jp>
In-Reply-To: <20080805.151642.31467169.taka@valinux.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue,  5 Aug 2008 11:31:47 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takahashi wrote:
> Hi, Andrea,
> 
> I'm working with Ryo on dm-ioband and other stuff.
> 
>>> On Mon, 2008-08-04 at 20:22 +0200, Andrea Righi wrote:
>>>> But I'm not yet convinced that limiting the IO writes at the device
>>>> mapper layer is the best solution. IMHO it would be better to throttle
>>>> applications' writes when they're dirtying pages in the page cache (the
>>>> io-throttle way), because when the IO requests arrive to the device
>>>> mapper it's too late (we would only have a lot of dirty pages that are
>>>> waiting to be flushed to the limited block devices, and maybe this could
>>>> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
>>>> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
>>>> not understood the dm-ioband approach.
>>> The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
>>> you look at this in combination with the memory controller, they would
>>> make a great team.
>>>
>>> The memory controller keeps you from dirtying more than your limit of
>>> pages (and pinning too much memory) even if the dm layer is doing the
>>> throttling and itself can't throttle the memory usage.
>> mmh... but in this way we would just move the OOM inside the cgroup,
>> that is a nice improvement, but the main problem is not resolved...
> 
> The concept of dm-ioband includes it should be used with cgroup memory
> controller as well as the bio cgroup. The memory controller is supposed
> to control memory allocation and dirty-page ratio inside each cgroup.
> 
> Some guys of cgroup memory controller team just started to implement
> the latter mechanism. They try to make each cgroup have a threshold
> to limit the number of dirty pages in the group.

Interesting, they also post a patch or RFC?

-Andrea
