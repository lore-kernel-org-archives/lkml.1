Return-Path: <linux-kernel-owner+w=401wt.eu-S932764Ab0AFUgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab0AFUgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932502Ab0AFUgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:36:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:55102 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab0AFUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:36:10 -0500
Message-ID: <4B44F3EA.7090002@windriver.com>
Date: Wed, 06 Jan 2010 14:34:50 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Sonic Zhang <sonic.adi@gmail.com>, "Zhang, Sonic" <Sonic.Zhang@analog.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc
 for blackfin
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261603190-5036-7-git-send-email-jason.wessel@windriver.com> <1261603190-5036-8-git-send-email-jason.wessel@windriver.com> <1261603190-5036-9-git-send-email-jason.wessel@windriver.com> <1261603190-5036-10-git-send-email-jason.wessel@windriver.com> <8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com> <0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com> <4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com> <4B44E7E3.10305@windriver.com> <8bd0f97a1001061208x8876e79y507d98e505071067@mail.gmail.com>
In-Reply-To: <8bd0f97a1001061208x8876e79y507d98e505071067@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2010 20:34:49.0227 (UTC) FILETIME=[B11D9DB0:01CA8F0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Wed, Jan 6, 2010 at 14:43, Jason Wessel wrote:
>   
>> I pulled in this patch, and made the changes the Mike talked about with
>> respect to cleaning up the arch specific kgdb.c for blackfin.  See the
>> attached patch.
>>
>> Your patch and the one here will go into kgdb-next and onto linux-next.
>>     
>
> the Blackfin versions tail into the common probe_kernel_{read,write}
>   

Got it.

> funcs, so your patch causes an infinite recursion in the common case.
> as i hinted earlier, i'd like to see mm/access.c to have something
> like:
> -long probe_kernel_read(void *dst, void *src, size_t size)
> +long __probe_kernel_read(void *dst, void *src, size_t size)
> ...
> +long __weak probe_kernel_read(void *dst, void *src, size_t size)
>     __attribute__((alias("__probe_kernel_read")));
> that way the arch-specific probe_kernel_read can still fall back to
> the common __probe_kernel_read function.  same goes for the write
> function.
>
>   

I don't see a problem with this.  Ingo was the originator of these
functions, which are mainly used for the kernel debugger.  The s390
already made one of them a weak function, so that arch specific code
might have to get looked at as well.

> also, i see you added "notrace" to the Blackfin probe_kernel_write ...
> was that intentional ?  if so, this should probably go into
> include/linux/uaccess.h instead
>   

The notrace was just a cut and paste of the original in mm/maccess.c

Jason.
