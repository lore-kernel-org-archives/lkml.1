Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYDRN3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYDRN3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYDRN3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:29:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:35176 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYDRN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:29:14 -0400
Message-ID: <4808A1C7.7000907@windriver.com>
Date: Fri, 18 Apr 2008 08:27:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tglx@linutronix.de, penberg@cs.helsinki.fi, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jmorris@namei.org,
       sds@tycho.nsa.gov
Subject: Re: 2.6.25-mm1: not looking good
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>	 <20080417164034.e406ef53.akpm@linux-foundation.org>	 <20080417171413.6f8458e4.akpm@linux-foundation.org>	 <48080FE7.1070400@windriver.com> <20080418073732.GA22724@elte.hu>	 <19f34abd0804180446u2d6f17damf391a8c0584358b8@mail.gmail.com>	 <20080418123439.GA17013@elte.hu>	 <19f34abd0804180541l7b4d14a6tb13bdd51dd533d70@mail.gmail.com>	 <48089BCA.1090704@windriver.com> <19f34abd0804180622l4f89191cp4cc7833822e058f5@mail.gmail.com>
In-Reply-To: <19f34abd0804180622l4f89191cp4cc7833822e058f5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2008 13:27:28.0748 (UTC) FILETIME=[F2C802C0:01C8A157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Apr 18, 2008 at 3:02 PM, Jason Wessel
> <jason.wessel@windriver.com> wrote:
>   
>> Vegard Nossum wrote:
>>  > On Fri, Apr 18, 2008 at 2:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>  >
>>  >>  * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>  >>
>>  >>  > With the patch below, it seems 100% reproducible to me (7 out of 7
>>  >>  > bootups hung).
>>  >>  >
>>  >>  > The number of loops it could do before hanging were, in order: 697,
>>  >>  > 898, 237, 55, 45, 92, 59
>>  >>
>>  >>  cool! Jason: i think that particular self-test should be repeated 1000
>>  >>  times before reporting success ;-)
>>  >>
>>  >
>>  > BTW, I just tested a 32-bit config and it hung after 55 iterations as well.
>>  >
>>  > Vegard
>>  >
>>  >
>>  >
>>  I assume this was SMP?
>>     
>
> Yes. But now that I realize this, I tried running same kernel with
> qemu, using -smp 16, and it seems to be stuck here:
>
>   

Unless you have a qemu with the NMI patches, kgdb does not work on SMP
with qemu.  The very first test is going to fail because the IPI sent by
the kernel is not handled in qemu's hardware emulation.

Jason.
