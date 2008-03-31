Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYCaQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYCaQfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYCaQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:35:13 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060AbYCaQfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:35:11 -0400
Message-ID: <47F112BD.4050801@sgi.com>
Date: Mon, 31 Mar 2008 09:35:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>	 <20080327231654.599276000@polaris-admin.engr.sgi.com>	 <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>	 <47ED0343.1070708@sgi.com>	 <36ca99e90803280754p1fbedbccp366366f0240fe5cc@mail.gmail.com>	 <47ED36B9.6000508@sgi.com> <36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
In-Reply-To: <36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Fri, Mar 28, 2008 at 7:19 PM, Mike Travis <travis@sgi.com> wrote:
>>  > Aren't the most cpumaps (like cpu/cpu*/topology/*_siblings or
>>  > node/node*/cpumap) bitmasks?
>>
>>  I did an informal survey and you are right, the majority of references do use
>>  cpumask_scnprintf instead of cpulist_scnprintf.  Maybe the later function was
>>  added later?
>>
>>  To me though, it would seem that:
>>
>>  240-255
>>
>>  is more readable than:
>>
>>  00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000ffff
>>
>>  And as I mentioned, bitmask_parselist() [libbitmask(3)] does parse the output.
> But libbitmask has a bitmask_parsehex() too. (but thanks for the
> pointer to this code).
> 
> Anyway, your above example is wrong, the most significant bits comes first:
> 
> ffff0000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
> 
> This makes it not more readable, but I think readability isn't in this
> case of that much importance.

The original problem was how to avoid allocating a large stack space to display
cpu ids.  By using cpulist_scnprintf, it accomplishes this without, what I think
is too much pain.  If it's really that much of a problem, I will rework this patch.
But the length of the line with 4096 cpus will be 1152 bytes  Is this really
better?

> 
> I further think, this problem could be easily solved, if NR_CPUS and
> possibly your nr_cpus_ids is somehow exported to user space.
> 
> With this information, the user is not surprised to see more that 1024
> bits (=CPU_SETSIZE, which is currently the glibc constant for the
> sched_{set,get}affinity() API). Also the glibc has the new variable
> cpu_set_t size API (since 2.7).

Yes, thanks.  That is being dealt with in another task.

Thanks,
Mike
