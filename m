Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYHUK1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYHUK1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYHUK0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:26:48 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:51634 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758253AbYHUK0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:26:46 -0400
Message-ID: <48AD42E1.40204@linux.vnet.ibm.com>
Date: Thu, 21 Aug 2008 15:56:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [discuss] memrlimit - potential applications that can use
References: <48AA73B5.7010302@linux.vnet.ibm.com> <1219161525.23641.125.camel@nimitz> <48AAF8C0.1010806@linux.vnet.ibm.com> <1219167669.23641.156.camel@nimitz> <48ABD545.8010209@linux.vnet.ibm.com> <1219249757.8960.22.camel@nimitz> <48ACE040.2030807@linux.vnet.ibm.com> <20080821164339.679212b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080821164339.679212b2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 21 Aug 2008 08:55:52 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>>>> So, before we expand the use of those features to control groups by
>>>>> adding a bunch of new code, let's make sure that there will be users
>>>> for
>>>>> it and that those users have no better way of doing it.
>>>> I am all ears to better ways of doing it. Are you suggesting that overcommit was
>>>> added even though we don't actually need it?
>>> It serves a purpose, certainly.  We have have better ways of doing it
>>> now, though.  "﻿So, before we expand the use of those features to
>>> control groups by adding a bunch of new code, let's make sure that there
>>> will be users for it and that those users have no better way of doing
>>> it."
>>>
>>> The one concrete user that's been offered so far is postgres.  I've
>> No, you've been offered several, including php and apache that use memory limits.
>>
>>> suggested something that I hope will be more effective than enforcing
>>> overcommit.  
> 
> I'm sorry I miss the point. My concern on memrlimit (for overcommiting) is that
> it's not fair because an application which get -ENOMEM at mmap() is just someone
> unlucky.

It can happen today with overcommit turned on. Why is it unlucky?

 I think it's better to trigger some notifier to application or daemon
> rather than return -ENOMEM at mmap(). Notification like "Oh, it seems the VSZ
> of total application exceeds the limit you set. Although you can continue your
> operation, it's recommended that you should fix up the  situation".
> will be good.
> 

So you are suggesting that when we are running out of memory (as defined by our
current resource constraints), we don't return -ENOMEM, but instead we now
handle a new event that states that we are running out of memory?

NOTE: I am not opposed to the event, it can be useful for container
administrators to know how to size their containers, not to application
developers who want to auto-tune their applications (see my comment on autonomic
computing in an earlier thread) or to applications that want to make sure they
don't OOM without the system administrator having to do oom_adj for every
important application.

> Thanks,
> -Kame
> 


-- 
	Balbir

