Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZLTPYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZLTPYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZLTPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:24:46 -0500
Received: from mx01.qsc.de ([213.148.129.14]:52417 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbZLTPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:24:46 -0500
Message-ID: <4B2E41BD.20708@googlemail.com>
Date: Sun, 20 Dec 2009 16:24:45 +0100
From: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
	<holger.hoffstaette@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
References: <pan.2009.12.19.15.10.48.851500@googlemail.com>	 <20091220054847.GF32739@1wt.eu> <4B2E10C6.7050304@googlemail.com>	 <20091220130616.GC9719@1wt.eu>  <4B2E264E.4090805@googlemail.com> <1261319400.6105.27.camel@marge.simson.net>
In-Reply-To: <1261319400.6105.27.camel@marge.simson.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the dupes)

Mike Galbraith wrote:
> On Sun, 2009-12-20 at 14:27 +0100, Holger Hoffstätte wrote:
> 
>> Took me some time (still learning git - I usually use hg) but I just
>> managed to fix it by reverting not the bisected revision (won't compile
>> any longer), but the follow-up "cleanup & fix":
>>
>> >From 35c1ee3e78766d5666f418af638def9c67e63ecb Mon Sep 17 00:00:00 2001
>> From: Mike Galbraith <efault@gmx.de>
>> Date: Tue, 10 Nov 2009 03:50:02 +0100
>> Subject: [PATCH] sched: Fix and clean up rate-limit newidle code
>>
>> commit eae0c9dfb534cb3449888b9601228efa6480fdb5 upstream.
>>
>> Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix
>> the netperf UDP loopback regression reported by Alex Shi.
>>
>> This is a cleanup and a fix:
>>
>>  - moved to a more out of the way spot
>>
>>  - fix to ensure that balancing doesn't try to balance
>>    runqueues which haven't gone online yet, which can
>>    mess up CPU enumeration during boot.
>>
>> Reported-by: Alex Shi <alex.shi@intel.com>
>> Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
>> Signed-off-by: Mike Galbraith <efault@gmx.de>
>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> aka:
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=35c1ee3e78766d5666f418af638def9c67e63ecb
>>
>> Reverting this from a clean 32.2 tree results in a kernel with newidle
>> fix, but still working halt/reboot. The only difference between this and
>> the bisected one is the additional change in cpumask handling.
>>
>> That was more fun than expected :)
> 
> Egad.  Reverting the cpumask bit alone cures the problem?

Yup. I manually changed both cpumask_copy(..) lines back to
cpumask_setall(..) in a clean .32.2 tree and can halt the resulting kernel
without problems.

Holger
