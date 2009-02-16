Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZBPXcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZBPXcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZBPXb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:31:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBPXb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:31:57 -0500
Message-ID: <4999F693.5000105@zytor.com>
Date: Mon, 16 Feb 2009 15:28:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <200902161753.14141.rusty@rustcorp.com.au> <4999A236.9040508@zytor.com> <200902170952.21063.rusty@rustcorp.com.au>
In-Reply-To: <200902170952.21063.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>
>> All in all I think a dedicated virtual zone per CPU as opposed to
>> interleaving them seems to make more sense.  Even with 4096 CPUs and
>> reserving, say, 256 MB per CPU it's not that much address space in the
>> context of a 47-bit kernel space.  On 32 bits I don't think anything but
>> the most trivial amount of percpu space is going to fly no matter what.
> 
> It's the TLB cost which I really don't want to pay; num_possible_cpus()
> 4096 non-NUMA is a little silly (currently impossible).
> 
> I'm happy to limit per-cpu allocations to pagesize, then you only need to
> find num_possible_cpus() contig pages, and if you can't, you fall back to
> vmalloc.
> 

num_possible_cpus() can be very large though, so in many cases the
likelihood of finding that many pages approach zero.  Furthermore,
num_possible_cpus() may be quite a bit larger than the actual number of
CPUs in the system.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

