Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYHKX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYHKX54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYHKX5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:57:47 -0400
Received: from gw.goop.org ([64.81.55.164]:55878 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbYHKX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:57:46 -0400
Message-ID: <48A0D1E6.5030609@goop.org>
Date: Mon, 11 Aug 2008 16:57:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 8] x86/smp function calls: convert x86 tlb flushes
 to use function calls
References: <patchbomb.1217636085@localhost> <87k5eu6d4f.fsf@basil.nowhere.org> <48991B84.2080704@goop.org> <20080806033736.GB24801@one.firstfloor.org>
In-Reply-To: <20080806033736.GB24801@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Micro benchmark. Just stick RDTSC around the calls and trigger
> a few remote flushes by e.g. doing mmap/munmap on a multithreaded program
> running on different CPUs.
>   

On a HT 3GHz Xeon, I see a ~35% increase in time (1830ns -> 2500ns), 
averaged over 1000,000 interrupts.  Because it's only 2 cpu, it ends up 
always using the smp_call_function_single path (but via the 
smp_call_function_mask path).

I need to try getting a more-cpu machine running native to do a proper 
test, esp to see if putting kmalloc on that path is very expensive or 
not.  (Is it worth using a kmem_cache?)

    J
