Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbZARINw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbZARINw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZARINo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:13:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:55031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756AbZARINo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:13:44 -0500
Message-ID: <4972E4AC.9080000@kernel.org>
Date: Sun, 18 Jan 2009 17:13:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] x86-64: Remove the PDA
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>	 <1232115396-26367-9-git-send-email-brgerst@gmail.com>	 <1232115396-26367-10-git-send-email-brgerst@gmail.com>	 <1232115396-26367-11-git-send-email-brgerst@gmail.com>	 <1232115396-26367-12-git-send-email-brgerst@gmail.com>	 <1232115396-26367-13-git-send-email-brgerst@gmail.com>	 <1232115396-26367-14-git-send-email-brgerst@gmail.com>	 <1232115396-26367-15-git-send-email-brgerst@gmail.com>	 <1232115396-26367-16-git-send-email-brgerst@gmail.com>	 <4972B5A1.9090708@kernel.org> <73c1f2160901172346k3d6170eeqd733724e3af84e95@mail.gmail.com>
In-Reply-To: <73c1f2160901172346k3d6170eeqd733724e3af84e95@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 08:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
>> How about something like the following?
>>
>> #define CANARY_OFFSET   40
>> #define CANARY_SIZE     8
>>
>> DECLARE_PER_CPU(unsigned long, stack_canary);
>>
>> and in linker script,
>>
>> PERCPU_VADDR_PREALLOC(0, :percpu, CANARY_OFFSET + CANARY_SIZE)
>> per_cpu__stack_canary = __per_cpu_start + CANARY_OFFSET;
>>
> 
> The thing I don't like about the prealloc method is that it puts the
> page-aligned variables at the end.  This leaves a gap which is
> unavailable for dynamic allocations.  Stealing 48 bytes from the
> bottom of the irqstack (which is 16k) keeps the page-aligned section
> at the start.  It's really no different than how the thread_info
> structure sits at the bottom of the process stack.
> 
> How about something like:
> union irq_stack_union {
> 	char irq_stack[IRQSTACKSIZE];
> 	struct {
> 		char pad[40];
> 		unsigned long stack_canary;
> 	}
> };
> 
> That documents the overlay better, and avoids having to touch the
> linker script.

I have no objection as long as it's sufficiently documented.

Thanks.

-- 
tejun
