Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbZAGMOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbZAGMOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZAGMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:14:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:50540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZAGMON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:14:13 -0500
Message-ID: <49649C65.6000706@kernel.org>
Date: Wed, 07 Jan 2009 21:13:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: travis@sgi.com, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>
In-Reply-To: <20090107120225.GA30651@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Jan 2009 12:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing people from the original thread and LKML as it seems to
require actual discussion.)

Hello, this thread started with me asking for help regarding
the zero-based percpu patches and the initial message is quoted
below.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Hello, Mike, Ingo.
>>
>> I was working on something which requires better dynamic per-cpu
>> performance and have been working on implementing it myself but
>> realized the strange gcc stack protector ABI limitation and with
>> Rusty's hint and googling found out that Mike already did the heavy
>> lifting.
>>
>> I read the "x86_64: Optimize percpu accesses" from July last year and
>> it looks like it got stuck on tool chain problem which showed up as
>> two problems (is one of the two resolved?).
>>
>> * Notifier call chain corruption
>>
>> * Stack overflow with default stack size
>>
>> >From the cpu_alloc thread from November, it seems Mike is quite
>> pre-occupied, so I'm willing to give it a shot as it's blocking stuff
>> I have in queue.  The problem is that I'm having problem finding some
>> information.
>>
>> 1. Mike seems to have splitted the patch but haven't posted them.
>>
>> 2. Ingo's x86/percpu-zerobased branch doesn't contain any revision not
>>    in the current upstream.  Maybe the commits got lost during merges?
>>
>> 3. What failed and what got fixed and how to reproduce the problem.
>>
>> So, can you please help me a bit?  I'll be happy to forward port the 
>> patches if they have bit-rotted.
> 
> hm, i zapped them two days ago, because they collided with Rusty's ongoing 
> percpu-alloc work in his tree. Mike should be able to tell you what the 
> plans are for the resurrection of those patches.

IIUC, Rusty is somewhat leaning toward limiting per-cpu area and using
static allocator. (right?)  As I was trying to do more stuff per-cpu
(not putting a lot of stuff into per-cpu area but even with small
things limited per-cpu area poses scalability problems), cpu_alloc
seems to fit the bill better.

Anyways, I think it's worthwhile to listen what people have on mind
regarding how per-cpu stuff should proceed.

Thanks.

-- 
tejun
