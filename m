Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXKKD3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXKKD3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXKKD3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:29:44 -0500
Received: from [222.73.24.84] ([222.73.24.84]:56276 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbXKKD3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:29:44 -0500
Message-ID: <47367737.8030901@cn.fujitsu.com>
Date: Sun, 11 Nov 2007 11:29:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: fix sysfs_show_{available,current}_clocksources()
 buffer overflow problem
References: <4732EAB4.5070605@cn.fujitsu.com> <20071108114741.GF2479@hacking> <20071108121117.GG2479@hacking>
In-Reply-To: <20071108121117.GG2479@hacking>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on 2007-11-8 20:11 WANG Cong wrote:
> On Thu, Nov 08, 2007 at 07:47:41PM +0800, WANG Cong wrote:
>> Yes, snprintf is safer than sprintf. But here, the 'count' will be
>> mis-pointed when snprintf returns no less than PAGE_SIZE (what you called
>> overflow). So you may also need:
>>
>> 	if (unlikely(count >= PAGE_SIZE))
>> 		count = PAGE_SIZE - 1;
>>
>> Just a simple guess. ;)
> 
> Or try scnprintf. ;)

We have discussed this problem. We think that it is better to return the return
value of kernel directly because this is the specification of the sysfs.

   (Version:2.6.24-rc2,File:Documentation/filesystems/sysfs.txt:198-201):
   198 - show() methods should return the number of bytes printed into the
   199   buffer. This is the return value of snprintf().
   200
   201 - show() should always use snprintf().

And the function which calls the show() methods uses BUG_ON() to check the
return value. If the return value is too big,it means something wrong.

If we use scnprintf, we may not know whether the resulting string is truncated
or not. Maybe A big bug is ignored.

