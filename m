Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYKMBU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYKMBU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKMBUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:20:48 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58086 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYKMBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:20:47 -0500
Message-ID: <491B80E8.4090107@linux.vnet.ibm.com>
Date: Thu, 13 Nov 2008 06:50:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       menage@google.com
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com> <20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com> <20081112160758.3dca0b22.akpm@linux-foundation.org> <20081113101344.6882c209.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081113101344.6882c209.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 12 Nov 2008 16:07:58 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Wed, 12 Nov 2008 12:26:56 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>>> +5.1 on_rmdir
>>> +set behavior of memcg at rmdir (Removing cgroup) default is "drop".
>>> +
>>> +5.1.1 drop
>>> +       #echo on_rmdir drop > memory.attribute
>>> +       This is default. All pages on the memcg will be freed.
>>> +       If pages are locked or too busy, they will be moved up to the parent.
>>> +       Useful when you want to drop (large) page caches used in this memcg.
>>> +       But some of in-use page cache can be dropped by this.
>>> +
>>> +5.1.2 keep
>>> +       #echo on_rmdir keep > memory.attribute
>>> +       All pages on the memcg will be moved to its parent.
>>> +       Useful when you don't want to drop page caches used in this memcg.
>>> +       You can keep page caches from some library or DB accessed by this
>>> +       memcg on memory.
>> Would it not be more useful to implement a per-memcg version of
>> /proc/sys/vm/drop_caches?  (One without drop_caches' locking bug,
>> hopefully).
>>
>> If we do this then we can make the above "keep" behaviour non-optional,
>> and the operator gets to choose whether or not to drop the caches
>> before doing the rmdir.
>>
>> Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
>> interface, and it doesn't have the obvious races which on_rmdir has,
>> etc.
>>
>> hm?
>>
> In my plan, I'll add
> 
> memory.shrink_usage interface to do and allows
> 
> #echo 0M > memory.shrink_memory_usage
> (you may swap tasks out if there is task..)
> 
> to drop pages.
> 

So, shrink_memory_usage is just for dropping caches? I don't understand the part
about swap tasks out.

> Balbir, how do you think ? I've already removed "force_empty".

Have you? Won't that go against API/ABI compatibility guidelines. I would
recommend cc'ing linux-api as well. Sorry, I missed the patch that removes
force_empty. Me culpa.

-- 
	Balbir
