Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXKAOlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXKAOlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbXKAOlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:41:00 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:18141 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbXKAOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=mLUGDS/cq4+cPwmYeuCZbTT5FaxixPYivkVoE0pUrpGHWUpLMs8uUDxYa/i6wUrzxDj3nya+IvpCdwo+EqKwoWqgq5jWk9bxWvj6P0bORBHxcy8KdSMWH1/ULdsTerDIe/Pnpu08j9otlePgDHD9/U/a3OOlW1kn5viO0+x5aOA=
Message-ID: <4729E567.1050402@gmail.com>
Date: Thu, 01 Nov 2007 10:40:39 -0400
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
In-Reply-To: <20071101140320.GC26879@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Introduce ticket lock spinlocks for x86 which are FIFO. The implementation
> is described in the comments. The straight-line lock/unlock instruction
> sequence is slightly slower than the dec based locks on modern x86 CPUs,
> however the difference is quite small on Core2 and Opteron when working out of
> cache, and becomes almost insignificant even on P4 when the lock misses cache.
> trylock is more significantly slower, but they are relatively rare.
> 
> On an 8 core (2 socket) Opteron, spinlock unfairness is extremely noticable,
> with a userspace test having a difference of up to 2x runtime per thread, and
> some threads are starved or "unfairly" granted the lock up to 1 000 000 (!)
> times. After this patch, all threads appear to finish at exactly the same
> time.

I had observed this phenomenon on some 8-ways here as well, but I didn't
have the bandwidth to code something up.  Thumbs up!

Regards,
-Greg
