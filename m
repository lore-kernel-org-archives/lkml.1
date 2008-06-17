Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYFQOVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYFQOVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYFQOVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:21:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55332 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757386AbYFQOVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:21:10 -0400
Message-ID: <4857C850.103@sgi.com>
Date: Tue, 17 Jun 2008 07:21:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Peschke <mp3@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
References: <20080530035620.587204923@sgi.com> <200806152033.02891.rusty@rustcorp.com.au> <Pine.LNX.4.64.0806160748050.19276@schroedinger.engr.sgi.com> <200806171024.40662.rusty@rustcorp.com.au>
In-Reply-To: <200806171024.40662.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 17 June 2008 00:52:08 Christoph Lameter wrote:
>> On Sun, 15 Jun 2008, Rusty Russell wrote:
>>>> 3. Some hooks for arches to override particular behavior as needed.
>>>>    F.e. IA64 allocates percpu structures in a special way. x86_64
>>>>    needs to do some tricks for the pda etc etc.
>>> IA64 is going to need some work, since dynamic percpu addresses won't be
>>> able to use their pinned TLB trick to get the local version.
>> The ia64 hook could simply return the address of percpu area that
>> was reserved when the per node memory layout was generated (which happens
>> very early during node bootstrap).
> 
> Apologies, this time I read the code.  I thought IA64 used the pinned TLB area 
> to access per-cpu vars under some circumstances, but they only do that via an 
> arch-specific macro.
> 
> So creating new congruent mappings to expand the percpu area(s) is our main 
> concern now?
> 
> Rusty.

Not exactly.  Getting the system to not panic early in the boot (before
x86_64_start_kernel()) is the primary problem right now.  This happens
in the tip tree with the change to use zero-based percpu offsets.  It
gets much farther on the linux-next tree.

Thanks,
Mike
