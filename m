Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbZICUge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbZICUge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbZICUgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:36:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZICUgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:36:33 -0400
Message-ID: <4AA02687.9080406@zytor.com>
Date: Thu, 03 Sep 2009 13:26:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, jeremy@goop.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org>
In-Reply-To: <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 01:03 PM, tip-bot for Jeremy Fitzhardinge wrote:
> Commit-ID:  1ea0d14e480c245683927eecc03a70faf06e80c8
> Gitweb:     http://git.kernel.org/tip/1ea0d14e480c245683927eecc03a70faf06e80c8
> Author:     Jeremy Fitzhardinge <jeremy@goop.org>
> AuthorDate: Thu, 3 Sep 2009 12:27:15 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 3 Sep 2009 21:30:51 +0200
> 
> x86/i386: Make sure stack-protector segment base is cache aligned
> 
> The Intel Optimization Reference Guide says:
> 
> 	In Intel Atom microarchitecture, the address generation unit
> 	assumes that the segment base will be 0 by default. Non-zero
> 	segment base will cause load and store operations to experience
> 	a delay.
> 		- If the segment base isn't aligned to a cache line
> 		  boundary, the max throughput of memory operations is
> 		  reduced to one [e]very 9 cycles.
> 	[...]
> 	Assembly/Compiler Coding Rule 15. (H impact, ML generality)
> 	For Intel Atom processors, use segments with base set to 0
> 	whenever possible; avoid non-zero segment base address that is
> 	not aligned to cache line boundary at all cost.
> 
> We can't avoid having a non-zero base for the stack-protector
> segment, but we can make it cache-aligned.
> 

With the new zero-based percpu segment, it seems we should be able to
subsume the stack protector into the percpu segment and reference both
via %gs -- we just have to reserve the first 24 bytes of the segment,
and being able to reduce the number of segments we need in the kernel is
good for multiple reasons.

Tejun - am I missing something why that would be hard or impossible?

	-hpa
