Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbXKKELl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbXKKELl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 23:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXKKELe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 23:11:34 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:48640 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXKKELd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 23:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JWPFWGqQlcqFzH+/rza4JwGngypHpzszvGDggyAKhnESNx7fomZce1asI8LmFbGXqewBfpSUKun/wXRaUrohMePJiXWxZ1wJYnkRTMCluqBYzaEPv/RUtjq5CK8F5RmJTJ4SaKwHy/I45apuI9DSxa/jOpD3IdTXP8vJU7o29Cg=
Date: Sun, 11 Nov 2007 12:09:50 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: fix
	sysfs_show_{available,current}_clocksources() buffer overflow
	problem
Message-ID: <20071111040950.GA2468@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <4732EAB4.5070605@cn.fujitsu.com> <20071108114741.GF2479@hacking> <20071108121117.GG2479@hacking> <47367737.8030901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47367737.8030901@cn.fujitsu.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 11:29:59AM +0800, Miao Xie wrote:
>on 2007-11-8 20:11 WANG Cong wrote:
>>On Thu, Nov 08, 2007 at 07:47:41PM +0800, WANG Cong wrote:
>>>Yes, snprintf is safer than sprintf. But here, the 'count' will be
>>>mis-pointed when snprintf returns no less than PAGE_SIZE (what you called
>>>overflow). So you may also need:
>>>
>>>	if (unlikely(count >= PAGE_SIZE))
>>>		count = PAGE_SIZE - 1;
>>>
>>>Just a simple guess. ;)
>>
>>Or try scnprintf. ;)
>
>We have discussed this problem. We think that it is better to return the 
>return
>value of kernel directly because this is the specification of the sysfs.
>
>  (Version:2.6.24-rc2,File:Documentation/filesystems/sysfs.txt:198-201):
>  198 - show() methods should return the number of bytes printed into the
>  199   buffer. This is the return value of snprintf().
>  200
>  201 - show() should always use snprintf().
>
>And the function which calls the show() methods uses BUG_ON() to check the
>return value. If the return value is too big,it means something wrong.
>
>If we use scnprintf, we may not know whether the resulting string is 
>truncated
>or not. Maybe A big bug is ignored.
>

Well, i know little about sysfs. So it was just a hint.

Anyway, thanks for your input!


