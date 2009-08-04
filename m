Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZHDIIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZHDIIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZHDIIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:08:02 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62505 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbZHDIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:07:59 -0400
Message-ID: <4A77EC0A.1040602@ct.jp.nec.com>
Date: Tue, 04 Aug 2009 17:06:34 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timers: fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
References: <4A764FF3.50607@ct.jp.nec.com>	<20090804002226.2972cf47.akpm@linux-foundation.org>	<4A77E62D.8070803@ct.jp.nec.com> <20090804005753.99e21163.akpm@linux-foundation.org>
In-Reply-To: <20090804005753.99e21163.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 04 Aug 2009 16:41:33 +0900 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> Userspace program is like this;
>>
>> #include <time.h>
>>
>> int main(void)
>> {
>> 	struct timespec ts;
>>
>> 	ts.tv_sec = 1;
>> 	ts.tv_nsec = 0;
>>
>> 	return clock_nanosleep(4, 0, &ts, NULL);
>> }
>>
>> and it will cause oops;
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> 
> Well that's not very good.
> 
> How far back does this go?  posix-timers.c hasn't changed in several
> kernel versions.

Not sure the exact version is. I've just noticed it on the latest git and
Fedora 11.
I guess after the below commit;
commit 2d42244ae71d6c7b0884b5664cf2eda30fb2ae68
Author: John Stultz <johnstul@us.ibm.com>
Date:   Wed Aug 20 16:37:30 2008 -0700

    clocksource: introduce CLOCK_MONOTONIC_RAW

thanks,
Hiroshi
