Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYGNQjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYGNQjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYGNQjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:39:03 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:1865 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYGNQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:39:02 -0400
To: "Rafael C. de Almeida" <almeidaraf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/data information
From: Andi Kleen <andi@firstfloor.org>
References: <487A606E.5040202@gmail.com>
Date: Mon, 14 Jul 2008 18:38:58 +0200
In-Reply-To: <487A606E.5040202@gmail.com> (Rafael C. de Almeida's message of "Sun, 13 Jul 2008 17:07:10 -0300")
Message-ID: <87ej5wzahp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2008 16:38:57.0564 (UTC) FILETIME=[1C9675C0:01C8E5D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael C. de Almeida" <almeidaraf@gmail.com> writes:

> I'm interested in knowing how the cpu data from /proc/stat is gathered.
> Following my way from this function:
>
> 	http://lxr.linux.no/linux+v2.6.25.10/fs/proc/proc_misc.c#L459
>
> I've figured that the time is probably gathered using those
> account_*_time on sched.c. I'm not sure where the times are read from,
> though.

They are normally (some architectures do it differently to cope with
virtualized environments) sampled by a regular timer interrupt, which
runs HZ times per second on each CPU. Common values for HZ is 250
(2.5ms interval), but you can compile with others too.

I suspect the effects you're seeing all come from sampling error.
The interval is also not fully stable because the kernel sometimes
disables interrupts and that will delay the timer interrupt of course.
How often this happens depends on the workload.

Then there are architectures like s390 who do "microstate accounting": 
they keep track instead on every kernel entry/exit and every interrupt.
That can be more accurate, but is also more costly.

-Andi
