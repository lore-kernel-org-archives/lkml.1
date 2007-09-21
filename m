Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXIUBEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXIUBEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIUBEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:04:16 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:59548 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXIUBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:04:16 -0400
Message-ID: <46F3188C.1040902@andrew.cmu.edu>
Date: Thu, 20 Sep 2007 21:04:12 -0400
From: Yucheng Low <ylow@andrew.cmu.edu>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
References: <46F0E19D.8000400@andrew.cmu.edu> <2c0942db0709200914p5ba04307pee519d4991f62299@mail.gmail.com>
In-Reply-To: <2c0942db0709200914p5ba04307pee519d4991f62299@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks all. After lots of testing, I isolated the problem to one of the
memory modules.

Thought it might have been a kernel problem as I thought memtest should
be exhaustive enough considering I ran it for so long, but apparently not...
Even now, the bad module still does not show any errors in memtest...

Thanks,
Yucheng

Ray Lee wrote:
> On 9/19/07, Low Yucheng <ylow@andrew.cmu.edu> wrote:
>   
>> [1.] Summary
>> System Freeze on Particular workload with kernel 2.6.22.6
>>
>> [2.] Description
>> System freezes on repeated application of the following command
>> for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done
>>
>> Problem is consistent and repeatable.
>> Problem persists when running on a different drive, and also in pure console (no X).
>>
>> One time, the following error logged in syslog:
>> Sep 19 04:22:11 mossnew kernel: [  301.883919] VM: killing process convert
>> Sep 19 04:22:11 mossnew kernel: [  301.884382] swap_free: Unused swap offset entry 0000ff00
>> Sep 19 04:22:11 mossnew kernel: [  301.884421] swap_free: Unused swap offset entry 00000300
>> Sep 19 04:22:11 mossnew kernel: [  301.884456] swap_free: Unused swap offset entry 00000200
>> Sep 19 04:22:11 mossnew kernel: [  301.884491] swap_free: Unused swap offset entry 0000ff00
>> Sep 19 04:22:11 mossnew kernel: [  301.884527] swap_free: Unused swap offset entry 0000ff00
>> Sep 19 04:22:11 mossnew kernel: [  301.884562] swap_free: Unused swap offset entry 00000100
>>
>> Should not be a RAM problem. RAM has survived 12 hrs of Memtest with no errors.
>> Should not be a CPU problem either. I have been running CPU intensive tasks for days.
>>     
>
> The "Unused swap offset entry" is almost always a sign of bad memory,
> if google can be trusted. Your workload is *extremely* CPU and memory
> intensive (and even hits the disk!), so this looks like bad RAM, bad
> cooling, or a marginal power supply that is failing under load.
>
> memtest86+ doesn't stress the CPU nearly as much, so it often doesn't
> show all the problems.
>
> Take your RAM down to one stick and try again (looks like you have 2G
> installed?). If that still fails, try different RAM. If that still
> fails, then swap out the power supply for another if you can, and try
> again.
>
> Ray
>
>   

