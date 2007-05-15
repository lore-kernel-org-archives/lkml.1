Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbXEOGHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbXEOGHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXEOGHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:07:47 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:59003 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbXEOGHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:07:46 -0400
Message-ID: <46494DFC.6080104@cosmosbay.com>
Date: Tue, 15 May 2007 08:06:52 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       dang@gentoo.org, Andi Kleen <ak@suse.de>
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in
 tv_usec on core2duo
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org> <20070514220901.90aab9e0.akpm@linux-foundation.org>
In-Reply-To: <20070514220901.90aab9e0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 15 May 2007 08:06:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Mon, 14 May 2007 21:17:47 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=8479
>>
>>            Summary: gettimeofday returning 1000000 in tv_usec on core2duo
>>     Kernel Version: 2.6.21
>>             Status: NEW
>>           Severity: normal
>>              Owner: ak@suse.de
>>          Submitter: dang@gentoo.org
>>
>>
>> Most recent kernel where this bug did *NOT* occur: 2.6.20
>> Distribution: Gentoo
>> Hardware Environment: core2duo T7200 (all reporters had this same CPU)
>> Software Environment: Linux 2.6.21, glibc 2.5
>> Problem Description:
>>
>> gettimeofday returns 1 - 1000000 in tv_usec, not 0 - 999999 
>> This does not happen on any of my AMD-based 32 or 64 bit boxes, only on my
>> core2duo; I have 2 other reports of this problem, all on T7200's
>>
>> Steps to reproduce:
>>
>> call gettimeofday a lot.  Eventually, you'll get 1000000 returned in tv_usec. My
>> average is ~1 in 1000000 calls.  I've attached my test program, with output from
>> various boxes.  One of the other reporters tried the test program too, and got
>> similar output.  .config will be attached too.
> 
> err, whoops.

I remember I already hit this and corrected it

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdiff;f=arch/x86_64/kernel/vsyscall.c;h=dc32cef961950915fbaa185e36ab802d5f7cea3b;hp=ba330f87067996a17495f7d03466d646c718b52c;hb=c8118c6c07f2edfd697aaa0b93e08c3b65a5a675;hpb=272a3713bb9e302e0455c894c41180a482d2c8a3

Maybe a stable push is necessary ?


