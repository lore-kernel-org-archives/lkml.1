Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYC2I7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYC2I7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 04:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYC2I72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 04:59:28 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:20644 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYC2I71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 04:59:27 -0400
Message-ID: <36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
Date: Sat, 29 Mar 2008 09:59:26 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <47ED36B9.6000508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
	 <20080327231654.599276000@polaris-admin.engr.sgi.com>
	 <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
	 <47ED0343.1070708@sgi.com>
	 <36ca99e90803280754p1fbedbccp366366f0240fe5cc@mail.gmail.com>
	 <47ED36B9.6000508@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 7:19 PM, Mike Travis <travis@sgi.com> wrote:
>  > Aren't the most cpumaps (like cpu/cpu*/topology/*_siblings or
>  > node/node*/cpumap) bitmasks?
>
>  I did an informal survey and you are right, the majority of references do use
>  cpumask_scnprintf instead of cpulist_scnprintf.  Maybe the later function was
>  added later?
>
>  To me though, it would seem that:
>
>  240-255
>
>  is more readable than:
>
>  00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000ffff
>
>  And as I mentioned, bitmask_parselist() [libbitmask(3)] does parse the output.
But libbitmask has a bitmask_parsehex() too. (but thanks for the
pointer to this code).

Anyway, your above example is wrong, the most significant bits comes first:

ffff0000,00000000,00000000,00000000,00000000,00000000,00000000,00000000

This makes it not more readable, but I think readability isn't in this
case of that much importance.

I further think, this problem could be easily solved, if NR_CPUS and
possibly your nr_cpus_ids is somehow exported to user space.

With this information, the user is not surprised to see more that 1024
bits (=CPU_SETSIZE, which is currently the glibc constant for the
sched_{set,get}affinity() API). Also the glibc has the new variable
cpu_set_t size API (since 2.7).

Bert
>
>  Thanks,
>  Mike
>
