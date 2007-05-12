Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXELJ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXELJ1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXELJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 05:27:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:55974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbXELJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 05:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=JzYOfDLoWmRTnwLCu8OtMv8EVj59FKCOyY9oNjf3PkhKK7CEcklLO0d2n8ZUu97bQe/02RvBzdwQZnTrhQQhqIf6ON9iM164bsB24rrDHOKs0WhGvTJ1yzR3whLgxHGn5Kp98BubiIJF04ONEojw5cmeDJKFj6MvOQycz4BuqVo=
Date: Sat, 12 May 2007 11:27:13 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
In-Reply-To: <20070511131541.992688403@chello.nl>
Message-ID: <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
References: <20070511131541.992688403@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 May 2007, Peter Zijlstra wrote:

>
> I was toying with a scalable rw_mutex and found that it gives ~10% reduction in
> system time on ebizzy runs (without the MADV_FREE patch).
>

You break priority enheritance on user space futexes! :-(
The problems is that the futex waiter have to take the mmap_sem. And as 
your rw_mutex isn't PI enabled you get priority inversions :-(

Esben
