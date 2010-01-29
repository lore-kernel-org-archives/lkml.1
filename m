Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295Ab0A2QZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0A2QZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700Ab0A2QZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:25:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab0A2QZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:25:46 -0500
Date: Fri, 29 Jan 2010 08:24:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com, hpa@zytor.com,
       eranian@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
In-Reply-To: <1264763023.4283.2213.camel@laptop>
Message-ID: <alpine.LFD.2.00.1001290822280.3768@localhost.localdomain>
References: <20100122155535.797688466@chello.nl>  <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>  <20100129020128.716af8fb.akpm@linux-foundation.org> <1264763023.4283.2213.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Jan 2010, Peter Zijlstra wrote:
> 
> *sigh* and here I though it being placed right next to hweight_long()
> which uses the arch hweightN() would be clue enough.

No. People who add new uses may be copying old uses, without looking at 
the definition.

Also, people who _change_ uses may be changing a value that used to be a 
constant into a variable when something is made more dynamic. At which 
point it really makes sense to have a function that requires a constant to 
_check_ that it gets a constant.

> If people are so clueless, who says they'll read a comment.. but sure I
> guess I can add one.

The comment nobody cares about. But surprisingly crap code generation? 
That's bad.

> Subject: bitops: Dummyify the compile-time hweight versions
> 
> Because it seems allowed to not think and write kernel code.

I would suggest you look in the mirror at some point.

		Linus
