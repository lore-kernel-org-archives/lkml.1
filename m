Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbXESOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbXESOda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 10:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbXESOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 10:33:24 -0400
Received: from mail.tmr.com ([64.65.253.246]:41639 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572AbXESOdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 10:33:23 -0400
Message-ID: <464F09F6.6080000@tmr.com>
Date: Sat, 19 May 2007 10:30:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       dang@gentoo.org, Andi Kleen <ak@suse.de>, stable@kernel.org
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in
   tv_usec on core2duo
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org>	<20070514220901.90aab9e0.akpm@linux-foundation.org>	<46494DFC.6080104@cosmosbay.com> <20070514232301.69e27bbe.akpm@linux-foundation.org>
In-Reply-To: <20070514232301.69e27bbe.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 15 May 2007 08:06:52 +0200 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Andrew Morton a écrit :
>>> On Mon, 14 May 2007 21:17:47 -0700 bugme-daemon@bugzilla.kernel.org wrote:
>>>
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=8479
>>>>
>>>>            Summary: gettimeofday returning 1000000 in tv_usec on core2duo
>>>>     Kernel Version: 2.6.21
>>>>             Status: NEW
>>>>           Severity: normal
>>>>              Owner: ak@suse.de
>>>>          Submitter: dang@gentoo.org
>>>>
>>>>
>>>> Most recent kernel where this bug did *NOT* occur: 2.6.20
>>>> Distribution: Gentoo
>>>> Hardware Environment: core2duo T7200 (all reporters had this same CPU)
>>>> Software Environment: Linux 2.6.21, glibc 2.5
>>>> Problem Description:
>>>>
>>>> gettimeofday returns 1 - 1000000 in tv_usec, not 0 - 999999 
>>>> This does not happen on any of my AMD-based 32 or 64 bit boxes, only on my
>>>> core2duo; I have 2 other reports of this problem, all on T7200's
>>>>
>>>> Steps to reproduce:
>>>>
>>>> call gettimeofday a lot.  Eventually, you'll get 1000000 returned in tv_usec. My
>>>> average is ~1 in 1000000 calls.  I've attached my test program, with output from
>>>> various boxes.  One of the other reporters tried the test program too, and got
>>>> similar output.  .config will be attached too.
>>> err, whoops.
>> I remember I already hit this and corrected it
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdiff;f=arch/x86_64/kernel/vsyscall.c;h=dc32cef961950915fbaa185e36ab802d5f7cea3b;hp=ba330f87067996a17495f7d03466d646c718b52c;hb=c8118c6c07f2edfd697aaa0b93e08c3b65a5a675;hpb=272a3713bb9e302e0455c894c41180a482d2c8a3
> 
> Oh, OK.
> 
>> Maybe a stable push is necessary ?
> 
> yup.  Please always think of -stable when preparing fixes.  I'm sure many
> useful fixes are slipping past simply because those who _are_ looking out
> for backportable fixes are missing things.
> 
That makes me feel better, I have been occasionally suggesting fixes 
posted here as candidates for stable, I was afraid I was being a PITA. I 
forgot about the "stable" address and have been bugging greg, I'll stop 
that.

> Greg, Chris: please consider c8118c6c07f2edfd697aaa0b93e08c3b65a5a675
> for -stable, if it isn't already there.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

