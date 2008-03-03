Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbYCCWqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbYCCWqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYCCWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:46:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:57122 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753566AbYCCWqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:46:39 -0500
X-Authenticated: #12956409
X-Provags-ID: V01U2FsdGVkX1+OXxVp0A+Of8GMiO8b49kxi7fMji8esYHMG70tW/
	Hs2WIuBM9ywSfL
Message-ID: <47CC7FEA.5050508@gmx.net>
Date: Mon, 03 Mar 2008 23:47:06 +0100
From: Cyrus Massoumi <cyrusm@gmx.net>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080227)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Diego Calleja <diegocg@gmail.com>, Stephen Cuppett <cuppett@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Performance versus FreeBSD 7.0
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> <200803040004.52299.nickpiggin@yahoo.com.au> <47CC4B3F.8060405@gmx.net> <200803040624.24119.nickpiggin@yahoo.com.au>
In-Reply-To: <200803040624.24119.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 04 March 2008 06:02, Cyrus Massoumi wrote:
>> Nick Piggin wrote:
>>> On Saturday 01 March 2008 01:54, Diego Calleja wrote:
>>>> El Fri, 29 Feb 2008 08:38:00 -0500, "Stephen Cuppett"
>>>> <cuppett@gmail.com>
>>> escribió:
>>>>> loads and 1500% at high loads. When compared with the best performing
>>>>> Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are
>>>> There has been some performance problems with sysbench performance in
>>>> linux which made it slower than freebsd, there were some patches to
>>>> speed things up, not sure if they have been merged.
>>> There definitely were performance problems with threaded malloc/free
>>> in the Linux kernel and glibc. Fixes have been merged in both packages,
>>> and AFAIK the FreeBSD guys tested with those fixes in place.
>>>
>>> I think these were never really run into before in part due to MySQL's
>>> unscalable heap design makes it not scale well on higher numbers of
>>> CPUs anyway, and also made the malloc problems more pronounced (ie.
>>> they added a bit to the contention of the single heap lock, which is
>>> the big killer here).
>> IIRC, going to fine-grained file locking gave them a huge boost in this
>> particular benchmark (and maybe others).
>> As I said on lwn.net Peter Zijlstra posted a patch to break the global
>> file list lock about a year ago [1], but I don't think it was ever
>> merged. Here [2] are some numbers for the patchset.
>>
>> [1] http://lkml.org/lkml/2007/1/28/29
>> [2] http://lkml.org/lkml/2007/1/28/116
> 
> The mysql workload is not constrained by this lock. The important
> part (where freebsd saw their gain) is probably fd lookups, which
> are lockless in Linux for a long time.

Thanks for pointing this out Nick.

