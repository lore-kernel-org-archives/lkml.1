Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYCZRfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYCZRfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYCZRfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:35:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57973 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYCZRfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:35:45 -0400
Date: Wed, 26 Mar 2008 18:35:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in
	intel_cacheinfo
Message-ID: <20080326173508.GI20016@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com> <20080326065023.GG18301@elte.hu> <47EA6EA3.1070609@sgi.com> <20080326171241.GC20016@elte.hu> <47EA87D8.8030305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EA87D8.8030305@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>> The main goal was to avoid allocating 4096 bytes when only 32 would do 
>>> (characters needed to represent nr_cpu_ids cpus instead of NR_CPUS cpus.) 
>>> But I'll look at cleaning it up a bit more.  It wouldn't have to be a 
>>> function if CHUNKSZ in cpumask_scnprintf() were visible (or a 
>>> non-changeable constant.)
>>
>> well, do we care about allocating 4096 bytes, as long as we also free it? 
>> It's not like we need to clear all the bytes or something. Am i missing 
>> something here?
>
> Well, 32 bytes fits on the stack, whereas 4096 bytes requires 
> allocating a page -- which means either taking the risk of failing or 
> blocking.  Of course, we're doing this for output, which has the same 
> issue.

hm, i thought this was all implemented via dynamic allocation already, 
within the cpumask_scnprintf function. But i see it doesnt do it - i 
guess a new call could be introduced, cpumask_scnprintf_ptr() which 
passes in a cpumask pointer and does dynamic allocation itself?

	Ingo
