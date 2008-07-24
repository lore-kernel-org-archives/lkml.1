Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYGXOaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYGXOaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYGXOaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:30:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:44150 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbYGXOaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:30:16 -0400
Message-ID: <488891F2.9020509@windriver.com>
Date: Thu, 24 Jul 2008 09:30:10 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com> <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
In-Reply-To: <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2008 14:30:11.0730 (UTC) FILETIME=[C7C33F20:01C8ED99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> On Thu, Jul 24, 2008 at 3:24 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>   
>> I wanted to give kgdb a try on a v2.6.26 kernel. My cpu is an
>> x86-64.
>>
>> So the first thing I did is to enable kgdb support and also the
>> kgdb self tests:
>>
>> CONFIG_HAVE_ARCH_KGDB=y
>> CONFIG_KGDB=y
>> CONFIG_KGDB_SERIAL_CONSOLE=y
>> CONFIG_KGDB_TESTS=y
>> # CONFIG_KGDB_TESTS_ON_BOOT is not set
>>
>> Once compiled I booted this kernel through qemu and got the following:
>>
>>     
>
> and unfortunately it seems this issue is related to qemu: if I did boot the
> kernel without qemu and the self tests passed...
>
>
>   

It is because the qemu you are using does not support hardware
breakpoints.  The tests will warn, but the kernel will continue to boot
and tell you that hw breakpoint support doesn't work on your simulated
hardware.

Also, if you plan to use software breakpoints, please make sure to turn
off CONFIG_DEBUG_RODATA, else they will not work.   This is a regression
which will is on my list of things to take a look at, as time permits.

Cheers,
Jason.
