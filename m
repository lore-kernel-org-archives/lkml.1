Return-Path: <linux-kernel-owner+w=401wt.eu-S934845AbYBUWP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbYBUWP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbYBUWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:15:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41398 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbYBUWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:15:16 -0500
Subject: Re: [PATCH 2/2] make work have a static address in do_boot_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, arjan@infradead.org
In-Reply-To: <1203626456-3101-3-git-send-email-gcosta@redhat.com>
References: <1203626456-3101-1-git-send-email-gcosta@redhat.com>
	 <1203626456-3101-2-git-send-email-gcosta@redhat.com>
	 <1203626456-3101-3-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 23:12:47 +0100
Message-Id: <1203631967.6112.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 17:40 -0300, Glauber Costa wrote:
> This patch makes the work field in create_idle have
> a static address. Otherwise, being a stack variable, it can
> boild down the lockdep system.

Looks way overkill. Doesn't something like:

> Signed-off-by: Glauber Costa <gcosta@redhat.com>
> ---
>  arch/x86/kernel/smpboot_64.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
> index f15b774..d79b7a8 100644
> --- a/arch/x86/kernel/smpboot_64.c
> +++ b/arch/x86/kernel/smpboot_64.c

> @@ -553,12 +554,12 @@ static int __cpuinit do_boot_cpu(int cpu
>  	unsigned long boot_error;
>  	int timeout;
>  	unsigned long start_rip;
> 	struct create_idle create_idle = {
> -		.work = __WORK_INITIALIZER(create_idle.work, do_fork_idle),
> 		.cpu = cpu,
> 		.done = COMPLETION_INITIALIZER_ONSTACK(create_idle.done),
> 	};
> +	INIT_WORK(&create_idle.work, do_fork_idle);

work?

