Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYLIGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYLIGgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 01:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYLIGgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 01:36:12 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:45577 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYLIGgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 01:36:11 -0500
Message-ID: <493E11D0.6020702@cosmosbay.com>
Date: Tue, 09 Dec 2008 07:36:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PACH] smp: uninline num_online_cpus() & num_possible_cpus()
References: <493965F8.6060407@cosmosbay.com> <200812091433.03670.rusty@rustcorp.com.au>
In-Reply-To: <200812091433.03670.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 09 Dec 2008 07:36:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> On Saturday 06 December 2008 04:03:44 Eric Dumazet wrote:
>> num_online_cpus() and num_possible_cpus() are not performance
>> critical and are quite large.
>>
>> Unlining them shrinks kernel text size by 7523 bytes on x86,
>> if NR_CPUS>32
> 
> Hi Eric!
> 
>   Slight misdiagnosis, I think.  One base problem is addressed in fixing
> the bitmap operators (see "[PATCH] bitmap: test for constant as well as
> small size for inline versions" on lkml Message-Id: <200811160907.07140.rusty@rustcorp.com.au>).  This is already in
> linux-next, and I've pasted it below.
> 
>   Worse, you used the obsolete cpumask operators :)
> 

I see ! Good work ;)

So the gain would be 11 bytes per call site, and about one hundred calls,
maybe not worth it :)

Thanks


