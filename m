Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYEKTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYEKTow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYEKToo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:44:44 -0400
Received: from mga12.intel.com ([143.182.124.36]:38867 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbYEKTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,469,1204531200"; 
   d="scan'208";a="245253784"
Message-ID: <48274C9E.3020608@linux.intel.com>
Date: Sun, 11 May 2008 12:44:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Error in save_stack_trace() on x86_64?
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
In-Reply-To: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> I am having a problem with v2.6.26-rc1 on x86_64. It seems that
> save_stack_trace() is not able to follow page fault boundaries, since
> all my saved traces look like this:
> 
> RIP: 0010:[<ffffffff8039b004>]  [<ffffffff8039b004>] add_uevent_var+0xb4/0x160
>     ...
>  [<ffffffff80221f97>] kmemcheck_read+0x127/0x1e0
>  [<ffffffff80222269>] kmemcheck_access+0x179/0x1d0
>  [<ffffffff8022231f>] kmemcheck_fault+0x5f/0x80
>  [<ffffffff8061cd1e>] do_page_fault+0x4de/0x8d0
>  [<ffffffff8061a7d9>] error_exit+0x0/0x51
>  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> I have this in my .config:
> 
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_STACKTRACE=y
> ...
> CONFIG_FRAME_POINTER=y
> ...
> CONFIG_DEBUG_INFO=y
> 
> 
> On 32-bit, I am able to see the calls leading up to the page fault as
> well. Did I miss something here?

can you give an example?

if a pagefault happens in userspace this trace looks correct.

if it happens in kernel space... I wonder if the separate exception stack thing
is hurting us with the stacks not being properly connected...
(but oopses and the like seem to come out just fine so I kinda doubt you're hitting that)
