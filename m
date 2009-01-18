Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbZARJFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbZARJFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 04:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763226AbZARJE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 04:04:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:43609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762906AbZARJEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 04:04:55 -0500
Message-ID: <4972F0AD.4030603@kernel.org>
Date: Sun, 18 Jan 2009 18:04:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <4972B6D9.4080101@kernel.org> <73c1f2160901172105p8ba1aa4v708e746d5548a79d@mail.gmail.com> <4972B967.4010606@kernel.org> <20090118083637.GA21940@elte.hu>
In-Reply-To: <20090118083637.GA21940@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 09:04:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, Brian.

Ingo Molnar wrote:
>> Sure, that's an option too but it might as well be done when making 
>> those percpu variables.  I don't really see why those two changes should 
>> be separate.  There isn't any reason why they shouldn't be separate 
>> either but if you're already mucking around every user...
> 
> yes, we should do the rename in this same patch as both patches have no 
> impact on the actual kernel image. (sans source code line and string 
> related deltas in the image.) Feel free to do the rename in his patch - 
> that's the fastest way.
> 
> I'd suggest to rename from:
> 
>   DECLARE_PER_CPU(char, irqstack[IRQSTACKSIZE]);
>   DECLARE_PER_CPU(char *, irqstackptr);
> 
> to:
> 
>   DECLARE_PER_CPU(char, irq_stack[IRQSTACKSIZE]);
>   DECLARE_PER_CPU(char *, irq_stack_ptr);
> 
> In other cases, lets get Brian's patches in without further latencies so 
> that we drain his pending-patches pipeline and get a consolidated base 
> everyone can work from. Brian already had an unfortunate (and 
> time-consuming) rebase/conflict-resolution pass due to us moving the 
> percpu code from under him. We can do non-critical followups in separate 
> delta patches.

Alright, there are other places where renaming would be nice -
kernelstack, oldrsp, irqcount, irqstackptr and isidle.  I'll rename
them as I add the patches.  Here's the plan.

	01-04	: w/ renames
	05	: will mark voyage broken
	06-12	: w/ renames
	13-17	: will wait for update

If anyone doesn't like it.  Please scream.

Thanks.

-- 
tejun
