Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYCKMD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYCKMD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYCKMDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:03:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:43163 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYCKMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QotRyYCN5Xcm971SBVy4b1GRJT8p3yHQ0mgIkOK3nyQf5Ku8indShqO0inf2oO4t1C64YothZJYoXKfaesjZoApPW8ChjlrjvQTXBIr3Ns/aPsiYnMnmEOvEXXKBbUO3W4fa6EOatu9Z6esM+N81GSjcfh7Em5SLow68EzZ8jbc=
Message-ID: <c4e36d110803110503v3f25d852nf52ebdc709d73706@mail.gmail.com>
Date: Tue, 11 Mar 2008 13:03:29 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH REPOST] Run IST traps from user mode preemptive on process stack
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, jkosina@suse.cz
In-Reply-To: <20080311012432.GA28576@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311012432.GA28576@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11, Andi Kleen <andi@firstfloor.org>:
> Run IST traps from user mode preemptive on process stack
>
>  [Repost. Please ack or nack. -Andi]
>
>  x86-64 has a few exceptions which run on special architecture
>  supported IST exception stacks: these are nmi, double fault, stack fault,
>   int 3, debug.
>
>  Previously they would check for a scheduling event on returning
>  if the original CPU state was user mode and then switch to a
>  process stack to schedule.
>
>  But the actual trap handler would still run on the IST stack
>  with preemption disabled.
>

Hi Andi

In my post where I've been showing BUG trace:

http://lkml.org/lkml/2008/3/10/157

I've mentioned my problem with busy looping in Qemu.

I'm not sure whether this is good or bad sign - but with this patch
you have posted,
I do not have to wait in qemu for minutes to get the 'busy-loop' - I
get the exact same loop almost instantly when I start  disk read of LV
partition and running my simple module insertion testcase.

>  This patch changes these traps instead to always switch
>  to the process stack when the trap originated from user mode.
>  For kernel traps it keeps running non preemptive on the IST stack
>   because that is much safer (e.g. to still get nmi watchdog events
>  out even when the process stack is corrupted)
>

So what should I check to get fixed my problem in qemu ?

Zdenek
