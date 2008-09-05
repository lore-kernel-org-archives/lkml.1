Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYIERS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYIERS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIERSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:18:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYIERSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:18:45 -0400
Subject: Re: [PATCH] Fixing section mismatch warning .
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       marcin.slusarz@gmail.com
In-Reply-To: <b9df5fa10809020843h2d264062g894b5a719dca9091@mail.gmail.com>
References: <b9df5fa10809020843h2d264062g894b5a719dca9091@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 19:18:40 +0200
Message-Id: <1220635120.11202.18.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 21:43 +0600, Rakib Mullick wrote:
> LD      kernel/built-in.o
> WARNING: kernel/built-in.o(.text+0x326): Section mismatch in reference
> from the function init_hrtick() to the variable
> ..cpuinit.data:hotplug_hrtick_nb.8
> The function init_hrtick() references
> the variable __cpuinitdata hotplug_hrtick_nb.8.
> This is often because init_hrtick lacks a __cpuinitdata
> annotation or the annotation of hotplug_hrtick_nb.8 is wrong.
> 
>  This patch fixes the above warning.
>  Thanks.
> 
> Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)
> 
> --- linux-2.6.27-rc5.orig/kernel/sched.c	2008-08-31 17:07:03.000000000 +0600
> +++ linux-2.6.27-rc5/kernel/sched.c	2008-09-01 22:23:30.000000000 +0600
> @@ -1087,7 +1087,7 @@ hotplug_hrtick(struct notifier_block *nf
>  	return NOTIFY_DONE;
>  }
> 
> -static void init_hrtick(void)
> +static __init void init_hrtick(void)
>  {
>  	hotcpu_notifier(hotplug_hrtick, 0);
>  }

then, shouldn't it be __cpuinit ?

BTW - would've been nice to see sched mentioned in the topic.

