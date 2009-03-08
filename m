Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZCHLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZCHLCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 07:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZCHLCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 07:02:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZCHLCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 07:02:11 -0400
Date: Sun, 8 Mar 2009 12:01:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090308110150.GA19151@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B23907.8030103@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Have i missed a mail of yours perhaps? I dont have any track of you 
>> having posted mmap-perf perfcounters results. I grepped my mbox and the 
>> last mail i saw from you containing the string "mmap-perf" is from 
>> January 20, and it only includes my numbers.
>
>
> Yes, I think you must have missed a mail. I've attached it for 
> reference, along with a more complete set of measurements I 
> made regarding the series of patches applied (series ending at 
> 1f4f931501e9270c156d05ee76b7b872de486304) to improve pvops 
> performance.

Yeah - indeed i missed those numbers - they were embedded in a 
spreadsheet document attached to the mail ;)

> My results showed a dramatic drop in cache references (from 
> about 300% pvop vs non-pvop, down to 125% with the full set of 
> patches applied), but it didn't seem to make much of an effect 
> on the overall wallclock time. I'm a bit sceptical of the 
> numbers here because, while each run's passes are fairly 
> consistent, booting and remeasuring seemed to cause larger 
> variations than we're looking at. It would be easy to handwave 
> it away with "cache effects", but its not very satisfying.

Well it's the L2 cache references which are being measured here, 
and the L2 cache is likely very large on your test-system. So we 
can easily run into associativity limits in the L1 cache while 
still being mostly in L2 cache otherwise.

Associativity effects do depend on the kernel image layout and 
on the precise allocations of kernel data structure allocations 
we do during bootup - and they dont really change after that.

> I also didn't find the measurements very convincing because 
> the number of CPU cycles and instructions executed count is 
> effectively unchanged (ie, the baseline non-pvops vs original 
> pvops apparently execute exactly the same number of 
> instructions, but we know that there's a lot more going on), 
> and with no change as each added patch definitely removes some 
> amount of pvops overhead in terms of instructions in the 
> instruction stream. Is it just measuring usermode stats? I ran 
> it as root, with the command line you suggested ("./perfstat 
> -e -5,-4,-3,0,1,2,3 ./mmap-perf 1"). Cache misses wandered up 
> and down in a fairly non-intuitive way as well.

It's measuring kernel stats too - and i very much saw the 
instruction count change to the tune of 10% or so.

> I'll do a rerun comparing current tip.git pvops vs non-pvops 
> to see if I can get some better results.

Thanks - i'll also try your patch on the same system i measured 
for my numbers so we'll have some comparison.

	Ingo
