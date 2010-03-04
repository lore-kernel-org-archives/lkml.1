Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0CDJgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:36:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab0CDJgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:36:40 -0500
Message-ID: <4B8F7F1A.6020000@cn.fujitsu.com>
Date: Thu, 04 Mar 2010 17:36:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
References: <4B8E3F77.6070201@cn.fujitsu.com> <20100304033017.GN8653@laptop>
In-Reply-To: <20100304033017.GN8653@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-4 11:30, Nick Piggin wrote:
> On Wed, Mar 03, 2010 at 06:52:39PM +0800, Miao Xie wrote:
>> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
>> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
>> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
>> use a rwlock to protect them to fix this probelm.
> 
> Thanks for working on this. However, rwlocks are pretty nasty to use
> when you have short critical sections and hot read-side (they're twice
> as heavy as even spinlocks in that case).
> 
> It's being used in the page allocator path, so I would say rwlocks are
> almost a showstopper. Wouldn't it be possible to use a seqlock for this?
> 

I will do my best to try to do it.

Thanks!
Miao

