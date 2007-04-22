Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXDVLKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXDVLKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030196AbXDVLKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:10:38 -0400
Received: from mail34.syd.optusnet.com.au ([211.29.133.218]:46068 "EHLO
	mail34.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030181AbXDVLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:10:37 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Michael Gerdau <mgd@technosis.de>
Subject: Re: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 21:09:23 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Al Boldi <a1426z@gawab.com>, Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704221441.48897.kernel@kolivas.org> <200704221002.21289.mgd@technosis.de>
In-Reply-To: <200704221002.21289.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222109.24294.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 18:02, Michael Gerdau wrote:
> Hi Con,
>
> I now have 2.6.21-rc7-sd-0.45 running on my Intel Core2 T7600 2.33
> machine and there is something I don't understand.
>
> For testing I have a Perl script that does some numbercrunching
> and runs a couple of hours.
>
> I have two scenarios
> a) start the job via loops in a shellscript
> b) start the job via a makefile (make -j 2)
> that I run in parallel.
>
> I watch the jobs via top and this is what I see:
> Job a) quickly gets about 100% (- 0-2) while job b) creates two
> perl jobs that both get 50% (- 0-2). I suppose it is expected
> behaviour that the single perl job created via a) gets same same
> share of the cpu as the two perl jobs created via b) together.
>
> However occasionally cpu drops to 33% for all three perl jobs
> while there is no other job visible in top (i.e. the sum drops
> from 200% to 100%). After some time this changes back to 100/50/50.
>
> How could this happen and would applying the other patch you
> mailed to Willy Tarreau help tracking that down ?

Thanks for report. That patch did not help Willy, and now you have confirmed 
there still is an SMP balancing problem too where it doesn't seem to keep all 
cpus busy. There's still a bug there in the smp balancing code and I'm 
reviewing it madly trying to find it. If anyone else knows this balancing 
code and is willing to help I'd be happy for feedback if they can see an 
obvious error. Likely thing is the runqueue is not being weighted at all 
despite being bust so the other runqueue doesn't try to take any tasks from 
it.

-- 
-ck
