Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZAaAgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZAaAgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZAaAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:35:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZAaAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:35:46 -0500
Message-ID: <49839CC8.7060502@zytor.com>
Date: Fri, 30 Jan 2009 16:35:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Martin Hicks <mort@sgi.com>
CC: tglx@linutronix.de, mingo@redhat.com, heukelum@mailshack.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com>
In-Reply-To: <49838F39.6060603@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Martin Hicks wrote:
>> Hi,
>>
>> KDB was using this information.  Could this be pushed towards 2.6.29 
>> please?
>>
>> This re-adds the old stack pointer to the top of the irqstack to help
>> with unwinding.  It was removed in commit 
>> d99015b1abbad743aa049b439c1e1dede6d0fa49
>> as part of the save_args out-of-line work.
>>
> 
> This bothers me... why should we add even a single instruction to what 
> is arguably the single hottest path in the kernel to support an 
> out-of-tree debugger, especially if kgdb (which is in-tree) doesn't need 
> it?
> 
> What does kgdb do differently (or is kgdb broken too)?
> 

Thinking about it some more, I think this makes sense under

#ifdef CONFIG_FRAME_POINTER

... since if we're not building with frame pointers, this is pretty 
pointless, and if we are, we're adding these all over the place anyway.

Does this work for you?  Let me know and I'll get it in if so.

	-hpa
