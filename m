Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0BATMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:12:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34268 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0BATMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:12:02 -0500
Message-ID: <4B672620.2040303@zytor.com>
Date: Mon, 01 Feb 2010 11:06:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       eranian@google.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] bitops: Provide compile time HWEIGHT{8,16,32,64}
References: <20100122155535.797688466@chello.nl>	 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>	 <20100129020128.716af8fb.akpm@linux-foundation.org>	 <1264763023.4283.2213.camel@laptop>  <4B636646.50605@zytor.com>	 <1264868891.24455.76.camel@laptop> <1265028224.24455.154.camel@laptop>
In-Reply-To: <1265028224.24455.154.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 04:43 AM, Peter Zijlstra wrote:
> 
> The below does work, but is still a tad ugly in that if you want to use
> any of the HWEIGHT functions that use BUILD_BUG_ON_ZERO() you have to
> have included linux/kernel.h yourself.
> 
> But at least it builds on x86_64, alpha and sparc64 (didn't have a ia64
> compiler around).
> 
> FWIW I was tempted to change the return type of hweight64() from
> unsigned long to unsigned int, its not as if it'll ever return a value
> larger than 64.
> 

That might generate worse code in some cases, though (something that
needs it as a 64-bit value would have to extend it unnecessarily), but
probably the easiest is to just compile and see what happens.

x86 also has a POPCNT instruction now, which we should be able to use
via alternatives.  That's something to do after your cleanup is in.

Anyway, I like the cleanup.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
